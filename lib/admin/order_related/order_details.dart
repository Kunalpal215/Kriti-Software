import 'package:flutter/material.dart';
class OrderDetails extends StatefulWidget {
  List orderInfo;
  OrderDetails({required this.orderInfo});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Widget itemInfoMaker(Map itemInfoMap, var screenWidth, var screenHeight){
    return Container(
      margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(itemInfoMap["imageURL"],width: screenWidth*0.23,height: screenWidth*0.23,fit: BoxFit.cover,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20,bottom: 10),
                    child: Text(
                      itemInfoMap["name"],
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
                          "Quantity : " + itemInfoMap["quantity"].toString(),
                          style: TextStyle(
                              fontFamily: "SFpro",
                              fontSize: screenWidth*0.04,
                              color: Colors.red,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: Text(
            //     "₹ " + (price*quantity).toString(),
            //     style: TextStyle(
            //         fontFamily: "SFpro",
            //         fontSize: screenWidth*0.05,
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold
            //     ),
            //   ),
            // ),
          ],
        )
    );
    // return Container(
    //   color: Colors.amber,
    //   padding: EdgeInsets.symmetric(vertical: 3),
    //   margin: EdgeInsets.symmetric(vertical: 2),
    //   child: Row(
    //     children: [
    //       Text("item name : " + itemInfoMap["name"]),
    //       Text(", quantity : " + itemInfoMap["quantity"].toString()),
    //     ],
    //   ),
    // );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<Widget> allItems = [];
    widget.orderInfo.forEach((element) {
      allItems.add(itemInfoMaker(element,screenWidth, screenHeight));
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Ordered Items",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: ListView(
        children: allItems,
      ),
    );
  }
}
