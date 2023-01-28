import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ItemInfoPage extends StatefulWidget {
  String itemName;
  String imageURL;
  int itemPrice;
  ItemInfoPage({required this.itemName,required this.imageURL, required this.itemPrice});

  @override
  _ItemInfoPageState createState() => _ItemInfoPageState();
}

class _ItemInfoPageState extends State<ItemInfoPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Item info page"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              widget.itemName,
              style: TextStyle(
                  fontSize: screenWidth*0.07,
                  fontFamily: "SFpro"
              ),
            ),
          ),
          Image.network(widget.imageURL,width: screenWidth*0.6,height: screenWidth*0.6,fit: BoxFit.cover,),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Text(
              "Price : ₹" + widget.itemPrice.toString() + "/pc",
              style: TextStyle(
                  fontSize: screenWidth*0.06,
                  fontFamily: "SFpro"
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    if(count>0) --count;
                  });
                },
                child: Image.asset("assets/minus.png",width: screenWidth*0.11,),
              ),
              Text(
                  "Quantity : " + count.toString(),
                style: TextStyle(
                  fontSize: screenWidth*0.07,
                  fontFamily: "SFpro"
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    ++count;
                  });
                },
                child: Image.asset("assets/plus.png",width: screenWidth*0.11,),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).get();
              List cartItems = userSnapshot.get("cart");
              bool found = false;
              // cartItems.forEach((element) {
              //   if(element["name"]==widget.itemName){
              //     element["quantity"] = count;
              //     found=true;
              //   }
              // });
              for(int i=0 ; i< cartItems.length ; i++){
                if(cartItems[i]["name"]==widget.itemName){
                  cartItems[i]["quantity"] = count;
                  found=true;
                }
              }
              if(found==false && count!=0){
                cartItems.add({"name" : widget.itemName, "quantity" : count});
              }
              if(found==true && count==0){
                cartItems.remove({"name" : widget.itemName, "quantity" : count});
              }
              await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).update({"cart" : cartItems});
              Navigator.pop(context);
              // if(count!=0){
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: SnackBar(content: Text("${count} of this item added to cart"),)));
              // }
              // else{
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: SnackBar(content: Text("this item was removed from your cart"),)));
              // }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(top: 7),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Text(
                "Add to cart",
                style: TextStyle(
                    fontFamily: "SFpro",
                    fontSize: screenWidth*0.06
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
