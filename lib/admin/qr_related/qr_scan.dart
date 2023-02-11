import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? qrViewController;

  @override
  void reassemble() async {
    super.reassemble();
    if(Platform.isAndroid){
      await qrViewController!.pauseCamera();
      return;
    }
    await qrViewController!.resumeCamera();
  }

  @override
  void dispose() {
    super.dispose();
    qrViewController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
          key: qrKey,
          onQRViewCreated: (controller){
            qrViewController=controller;
            controller.scannedDataStream.listen((barcode) async {
              String qrInsideCode = barcode.code!;
              if(qrInsideCode=="Order already fulfilled"){
                return;
              }
              print(qrInsideCode);
              int diffIndex = qrInsideCode.indexOf("/");
              String email = qrInsideCode.substring(0,diffIndex);
              String orderID = qrInsideCode.substring(diffIndex+1);
              DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection('users').doc(email).collection('currentOrders').doc(orderID).get();
              DocumentSnapshot currentOrderInfo = await FirebaseFirestore.instance.collection('admin').doc("currentOrder").get();
              if(currentOrderInfo.get("orderNumber") == orderSnapshot.get("orderNumber")){
                QuerySnapshot nextOrderQuerySnapshot = await FirebaseFirestore.instance.collection('admin').doc("order-queue").collection("allPendingOrders").orderBy("timestamp").limit(2).get();
                if(nextOrderQuerySnapshot.docs.length>1){
                  await FirebaseFirestore.instance.collection('admin').doc("currentOrder").update({
                    "email" : nextOrderQuerySnapshot.docs[1]["email"],
                    "order-info" : nextOrderQuerySnapshot.docs[1]["orderInfo"],
                    "orderNumber" : currentOrderInfo.get("orderNumber"),
                    "orderFulfilled" : false,
                  });
                }
                else{
                  await FirebaseFirestore.instance.collection('users').doc(email).collection("currentOrders").doc(orderID).update({"orderFulfilled" : true});
                }
              }
              await FirebaseFirestore.instance.collection('admin').doc("order-queue").collection("allPendingOrders").doc(orderID).delete();
            });
          },
          overlay: QrScannerOverlayShape(),
      ),
    );
  }
}
