import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/admin/order_related/order_details.dart';
class OrderQueueList extends StatefulWidget {
  const OrderQueueList({Key? key}) : super(key: key);

  @override
  _OrderQueueListState createState() => _OrderQueueListState();
}

class _OrderQueueListState extends State<OrderQueueList> {

  Widget OrderShowTile (int orderNumber,List orderInfo, var screenWidth, var screenHeight){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(orderInfo: orderInfo)));
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
        child: Text(
          "Order no. : " + orderNumber.toString(),
          style: TextStyle(
            fontFamily: "SFpro",
            fontSize: screenWidth*0.05
          ),
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
          "All pending orders",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admin').doc("order-queue").collection("allPendingOrders").orderBy("timestamp").snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<Widget> allItems = [];
            snapshot.data!.docs.forEach((element) => {
              allItems.add(OrderShowTile(element.get("orderNumber"), element.get("orderInfo"),screenWidth,screenHeight))
            });
            return ListView(
              children: allItems,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
