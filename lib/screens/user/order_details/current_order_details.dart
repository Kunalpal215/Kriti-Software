import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class CurrentOrderDetails extends StatefulWidget {
  String orderID;
  DateTime orderDateTime;
  int orderNumber;
  int totalBill;
  List allOrderedItems;
  CurrentOrderDetails({required this.orderID,required this.orderDateTime, required this.orderNumber, required this.totalBill, required this.allOrderedItems});
  @override
  _CurrentOrderDetailsState createState() => _CurrentOrderDetailsState();
}

class _CurrentOrderDetailsState extends State<CurrentOrderDetails> {

  Future<void> onOrderFulfillment(String orderID, BuildContext context) async {
    DocumentSnapshot orderDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection('currentOrders').doc(orderID).get();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection('recentOrders').doc(orderID).set({"order-info" : orderDocumentSnapshot.get("order-info"),"orderNumber" : orderDocumentSnapshot.get("orderNumber"),"timestamp":orderDocumentSnapshot.get("timestamp"),"totalBill" : orderDocumentSnapshot.get("totalBill")});
    Navigator.pop(context);
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection('currentOrders').doc(orderID).delete();
  }

  Widget CartItemTileMaker (String itemName, int quantity, int price,String imageURL,var screenWidth){
    print(itemName + " " + quantity.toString() + " " + price.toString());
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(imageURL,width: screenWidth*0.23,height: screenWidth*0.23,fit: BoxFit.cover,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20,bottom: 10),
                    child: Text(
                      itemName,
                      style: TextStyle(
                          fontFamily: "SFpro",
                          fontSize: screenWidth*0.05,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Quantity : " + quantity.toString(),
                          style: TextStyle(
                              fontFamily: "SFpro",
                              fontSize: screenWidth*0.04,
                              color: Colors.red,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          "₹ ${price} × ${quantity}",
                          style: TextStyle(
                            fontFamily: "SFpro",
                            fontSize: screenWidth*0.04,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "₹ " + (price*quantity).toString(),
                style: TextStyle(
                    fontFamily: "SFpro",
                    fontSize: screenWidth*0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget topBar(var screenWidth, var screenHeight){
    return Container(
      height: screenHeight*0.07,
      color: Colors.cyanAccent,
      alignment: Alignment.center,
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Order ID : " + widget.orderID + ", Order no."+ widget.orderNumber.toString(),
          style: TextStyle(
            fontSize: screenWidth*0.04,
            fontFamily: "SFpro",
          ),
        ),
      ),
    );
  }

  Widget QrGenerator(){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection("currentOrders").doc(widget.orderID).snapshots(),
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          String qrData = FirebaseAuth.instance.currentUser!.email! + "/" + widget.orderID;
          if(snapshot.data.get("orderFulfilled")==true){
            qrData = "Order already fulfilled";
            onOrderFulfillment(widget.orderID, context);
          }
          return Center(
            child: QrImage(
              data: qrData,
              size: 200,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget cartTotal (int total, var screenWidth){
    return Container(
      padding: EdgeInsets.only(left: 15,top: 15,bottom: 10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffE4C083),
        borderRadius: BorderRadius.circular(15),

      ),
      child: Row(
        children: [
          Text(
            "Subtotal : ",
            style: TextStyle(
                fontSize: screenWidth*0.05,
                fontFamily: "SFpro"
            ),
          ),
          Text(
            "₹ " + total.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth*0.06,
                fontFamily: "SFpro"
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Widget> toShow = [];
    toShow.add(topBar(screenWidth, screenHeight));
    widget.allOrderedItems.forEach((element) {
      toShow.add(CartItemTileMaker(element["name"], element["quantity"], element["price"], element["imageURL"], screenWidth));
    });
    toShow.add(cartTotal(widget.totalBill, screenWidth));
    toShow.add(QrGenerator());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Order Details",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: ListView(
        children: toShow,
      ),
    );
  }
}
