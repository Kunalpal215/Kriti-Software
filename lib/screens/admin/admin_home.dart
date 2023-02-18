import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/admin/items_related/add_item.dart';
import 'package:food_hut/screens/admin/items_related/update_item_info.dart';
import 'package:food_hut/screens/admin/order_related/order_queue_list.dart';
import 'package:food_hut/screens/admin/qr_related/qr_scan.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
            "Admin Home",
          style: TextStyle(
              color: Colors.white,
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFoodItem()));
    },
            child: Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Add Item",
                    style: TextStyle(
                      fontFamily: "SFpro",
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight*0.033
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrScannerScreen()));
            },
            child: Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scan QR",
                    style: TextStyle(
                        fontFamily: "SFpro",
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight*0.033
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateItemInfo()));
            },
            child: Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Update Item",
                    style: TextStyle(
                        fontFamily: "SFpro",
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight*0.033
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderQueueList()));
            },
            child: Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Orders Queue",
                    style: TextStyle(
                        fontFamily: "SFpro",
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight*0.033
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
