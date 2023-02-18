import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cool_alert/cool_alert.dart';
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  List<Map<String,dynamic>> cartItemsList = [];
  List<Widget> allCartItemsToShow = [];
  DocumentSnapshot? userSnapshot;
  int totalBill = 0;

  Widget onLoading(){
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void reload(){
    setState((){
      cartItemsList.clear();
      allCartItemsToShow.clear();
      totalBill=0;
      isLoading=true;
    });
  }

  Widget CartItemTileMaker (String itemName, int quantity, int price,String imageURL,var screenWidth){
    print(itemName + " " + quantity.toString() + " " + price.toString());
    return PopupMenuButton(
      itemBuilder: (context){
        return [
          PopupMenuItem(
            value: "random",
              child: Text("Delete")
          )
        ];
      },
        onSelected: (value){
          print("here");
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email).update({"cart" : FieldValue.arrayRemove([{"name" : itemName,"quantity" : quantity}])}).then((value) => reload());
          print("item deleted");
        },
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

  Widget cartTotal (int total, var screenWidth){
    return Container(
      padding: EdgeInsets.only(left: 15,top: 15,bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xffE4C083),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),

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

  Widget cartBottom (var screenWidth){
    return Row(
        children: [
          GestureDetector(
            onTap: (){
              print("Pressed 2");
            },
            child: Container(
              width: screenWidth*0.5,
              color: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: screenWidth*0.05),
              alignment: Alignment.center,
              child: Text("Make Changes"),
            ),
          ),
          GestureDetector(
            onTap: () async {
              CoolAlert.show(context: context, type: CoolAlertType.loading, text: "Just a second...");
              await FirebaseFirestore.instance.runTransaction((transaction) async {
                String orderID = Uuid().v4();
                DateTime dateTime = DateTime.now();
                DocumentReference postRef = await FirebaseFirestore.instance.collection('admin').doc("lastOrder");
                DocumentSnapshot snapshot = await transaction.get(postRef);
                int orderNumber = snapshot.get("orderNumber");
                transaction.update(postRef, {
                  "orderNumber" : orderNumber + 1,
                  "email" : FirebaseAuth.instance.currentUser!.email!,
                });
                if(orderNumber==0){
                  await FirebaseFirestore.instance.collection('admin').doc("currentOrder").update({"email" : FirebaseAuth.instance.currentUser!.email!, "orderNumber" : orderNumber+1,"order-info" : cartItemsList,"orderNumber" : 1,"orderFulfilled" : true});
                }
                FirebaseFirestore.instance.collection('admin').doc("order-queue").collection("allPendingOrders").doc(orderID).set({"timestamp" : dateTime.microsecondsSinceEpoch,"email" : FirebaseAuth.instance.currentUser!.email!,"orderInfo" : cartItemsList,"orderNumber": (orderNumber+1)});
                DocumentSnapshot currentOrderSnapshot = await FirebaseFirestore.instance.collection('admin').doc("currentOrder").get();
                if(orderNumber!=0 && currentOrderSnapshot.get("orderFulfilled")==true){
                  QuerySnapshot pendingOrdersSnapshot = await FirebaseFirestore.instance.collection('admin').doc("order-queue").collection('allPendingOrders').orderBy("timestamp").limit(1).get();
                  await FirebaseFirestore.instance.collection('admin').doc("currentOrder").update({"email" : pendingOrdersSnapshot.docs[0]["email"],"order-info" : pendingOrdersSnapshot.docs[0]["orderInfo"],"orderNumber" : pendingOrdersSnapshot.docs[0]["orderNumber"], "orderFulfilled" : false});
                }
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).collection("currentOrders").doc(orderID).set({"timestamp" : dateTime.microsecondsSinceEpoch,"order-info" : cartItemsList, "orderNumber" : (orderNumber+1),"orderFulfilled" : false,"totalBill" : totalBill});
              });
              Navigator.pop(context);
              CoolAlert.show(context: context, type: CoolAlertType.success,text: "Your order got placed");
              await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).update({"cart" : []});
              setState(() {
                allCartItemsToShow=[];
                cartItemsList=[];
                isLoading = true;
                totalBill=0;
              });
            },
            child: Container(
              width: screenWidth*0.5,
              color: Colors.yellow,
              padding: EdgeInsets.symmetric(vertical: screenWidth*0.05),
              alignment: Alignment.center,
              child: Text("Buy Now"),
            ),
          ),
        ],
    );
  }

  Future<void> getCartItems(var screenWidth) async {
    print("fetching cart items");
    userSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).get();
    List items = userSnapshot!.get("cart");
    QuerySnapshot foodItemsDoc = await FirebaseFirestore.instance.collection("food_items").get();
    Map<String,List> nameDetailsMap = {};
    print("here");
    foodItemsDoc.docs.forEach((element) {
      if(element.id!="sample") nameDetailsMap[element.get("name")] = [element.get("price"),element.get("imageURL")];
    });
    items.forEach((element){
      print("YES");
      cartItemsList.add({"name" : element["name"],"quantity" : element["quantity"],"price" : nameDetailsMap[element["name"]]![0],"imageURL" : nameDetailsMap[element["name"]]![1]});
    });
    print("HELLO 1");
    cartItemsList.forEach((element) {
      print("HELLO BTWN");
      int itemTotal = element["quantity"] * element["price"];
      totalBill = totalBill + itemTotal;
      allCartItemsToShow.add(CartItemTileMaker(element["name"], element["quantity"], element["price"],element["imageURL"],screenWidth));
    });
    print("HELLO 2");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if(isLoading==true) getCartItems(screenWidth);
    return isLoading == true ? onLoading() : Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Stack(
        children: [
          Positioned(
            child: ListView(
              children: allCartItemsToShow,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                cartTotal(totalBill,screenWidth),
                cartBottom(screenWidth),
              ],
            ),
          ),
        ],
      )
    );
  }
}
