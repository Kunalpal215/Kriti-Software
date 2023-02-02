import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/user/order_details/current_order_details.dart';
class UserCurrentOrders extends StatefulWidget {
  @override
  _UserCurrentOrdersState createState() => _UserCurrentOrdersState();
}

class _UserCurrentOrdersState extends State<UserCurrentOrders> {
  bool isLoading = true;

  Widget onLoading(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Text("Loading your orders")
          ],
        ),
      ),
    );
  }

  Widget orderShowList(DateTime orderDateTime, String orderID, int orderNumber, int totalBill, List<dynamic> allOrderedItems,var screenWidth, var screenHeight){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CurrentOrderDetails(orderID: orderID, orderDateTime: orderDateTime, orderNumber: orderNumber, totalBill: totalBill, allOrderedItems: allOrderedItems)));
      },
      child: Container(
        height: screenHeight*0.055,
        width: screenWidth*0.8,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Date: " + orderDateTime.day.toString() + "-" + orderDateTime.month.toString() + "-" + orderDateTime.year.toString(),
              style: TextStyle(
                  fontFamily: "SFpro",
                  fontSize: screenWidth*0.05
              ),
            ),
            Text(
                " Order: " + orderNumber.toString(),
              style: TextStyle(
                  fontFamily: "SFpro",
                  fontSize: screenWidth*0.05
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "All current orders",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection("currentOrders").snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<Widget> currentOrders = [];
            snapshot.data.docs.forEach(
                (element){
                  DateTime orderDateTime = DateTime.fromMicrosecondsSinceEpoch(element.get("timestamp"));
                  currentOrders.add(orderShowList(orderDateTime,element.id,element.get("orderNumber"),element.get("totalBill"),element.get("order-info"),screenWidth,screenHeight));
                }
            );
            return ListView(
              children: currentOrders,
            );
          }
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text("Loading..."),
              ],
            ),
          );
        },
      ),
    );
  }
}
