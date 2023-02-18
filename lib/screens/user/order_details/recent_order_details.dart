import 'package:flutter/material.dart';
class RecentOrderDetails extends StatefulWidget {
  String orderID;
  DateTime orderDateTime;
  int orderNumber;
  int totalBill;
  List allOrderedItems;
  RecentOrderDetails({required this.orderID,required this.orderDateTime, required this.orderNumber, required this.totalBill, required this.allOrderedItems});
  @override
  _RecentOrderDetailsState createState() => _RecentOrderDetailsState();
}

class _RecentOrderDetailsState extends State<RecentOrderDetails> {

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Old Order Details",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: ListView(
        children: toShow
      ),
    );
  }
}
