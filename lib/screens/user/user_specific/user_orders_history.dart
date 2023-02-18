import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/user/order_details/recent_order_details.dart';
class UserOrderHistory extends StatefulWidget {
  const UserOrderHistory({Key? key}) : super(key: key);

  @override
  _UserOrderHistoryState createState() => _UserOrderHistoryState();
}

class _UserOrderHistoryState extends State<UserOrderHistory> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Widget orderHistoryTile(DateTime orderDateTime, String orderID, int orderNumber, int totalBill, List<dynamic> allOrderedItems,var screenWidth, var screenHeight){
      return GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecentOrderDetails(orderID: orderID, orderDateTime: orderDateTime, orderNumber: orderNumber, totalBill: totalBill, allOrderedItems: allOrderedItems)));
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            "All past orders",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection('recentOrders').orderBy("timestamp").snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<Widget> recentOrders = [];
            snapshot.data.docs.forEach(
                    (element){
                  DateTime orderDateTime = DateTime.fromMicrosecondsSinceEpoch(element.get("timestamp"));
                  recentOrders.add(orderHistoryTile(orderDateTime, element.id, element.get("orderNumber"), element.get("totalBill"), element.get("order-info"),screenWidth,screenHeight));
                }
            );
            return ListView(
              children: recentOrders,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
