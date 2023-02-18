import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/user/food_item/item_info_page.dart';
import 'package:food_hut/screens/user/user_specific/cart_page.dart';
import 'package:food_hut/screens/user/user_specific/user_current_orders.dart';
import 'package:food_hut/screens/user/user_specific/user_orders_history.dart';
import 'package:food_hut/screens/user/welcome_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget foodItemTileMaker(String itemName, String itemImageURL, int price,var screenWidth){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemInfoPage(itemName: itemName, imageURL: itemImageURL, itemPrice: price)));
      },
      child: Container(
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(itemImageURL,width: screenWidth*0.27,height: screenWidth*0.23,fit: BoxFit.cover,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    itemName,
                    style: TextStyle(
                        fontSize: screenWidth*0.045,
                        fontFamily: "SFpro"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "₹ " + price.toString() + " /pc",
                    style: TextStyle(
                        fontSize: screenWidth*0.04,
                        fontFamily: "SFpro"
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }

  Widget orderStatusInfo (AsyncSnapshot currentOrderSnapshot,var screenHeight){
    return Container(
      margin: EdgeInsets.all(10),
      height: screenHeight*0.2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.cyanAccent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Current Order no. ",
            style: TextStyle(
                fontFamily: "SFpro",
                fontSize: screenHeight*0.03
            ),
          ),
          Text(
            currentOrderSnapshot.data.get("orderNumber") == 0 ? "Nil" : currentOrderSnapshot.data.get("orderNumber").toString(),
            style: TextStyle(
              fontFamily: "SFpro",
              fontWeight: FontWeight.bold,
              fontSize: screenHeight*0.04
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Colors.cyan,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 60),
            children: [
              GestureDetector(
                onTap: () async {

                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Your Profile",
                          style: TextStyle(
                            fontFamily: "SFpro",
                            fontSize: screenWidth*0.044,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.shopping_cart),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                            "Your Cart",
                          style: TextStyle(
                            fontFamily: "SFpro",
                            fontSize: screenWidth*0.044,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserCurrentOrders()));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.fastfood),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Your Orders",
                          style: TextStyle(
                            fontFamily: "SFpro",
                            fontSize: screenWidth*0.044,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserOrderHistory()));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.history_rounded),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Orders History",
                          style: TextStyle(
                            fontFamily: "SFpro",
                            fontSize: screenWidth*0.044,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route){
                    if(route.isFirst){
                      return true;
                    }
                    return false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.logout),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            fontFamily: "SFpro",
                            fontSize: screenWidth*0.044,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("food_items").snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<Widget> allItems = [];
            snapshot.data.docs.forEach((element){
              if(element.get("outOfStock")==false){
                allItems.add(foodItemTileMaker(element.get("name"), element.get("imageURL"), element.get("price"),screenWidth));
              }
            });
            return Stack(
              children: [
                ListView(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('admin').doc("currentOrder").snapshots(),
                      builder: (context,AsyncSnapshot snapshot){
                        if(snapshot.hasData){
                          return orderStatusInfo(snapshot, screenHeight);
                        }
                        return Container();
                      },
                    ),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: allItems,
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 25,
                  child: GestureDetector(
                    onTap: (){
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      height: screenWidth*0.13,
                      width: screenWidth*0.13,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(screenWidth*0.05)
                      ),
                      child: Icon(
                          Icons.menu,
                        size: screenWidth*0.08,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}
