import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/admin/items_related/update_item_screen.dart';
class UpdateItemInfo extends StatefulWidget {
  const UpdateItemInfo({Key? key}) : super(key: key);
  @override
  _UpdateItemInfoState createState() => _UpdateItemInfoState();
}

class _UpdateItemInfoState extends State<UpdateItemInfo> {

  Widget foodItemTileMaker(String docID,String itemName, String itemImageURL, int price,var screenWidth){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateItemScreen(docID: docID, itemName: itemName, price: price, imageURL: itemImageURL)));
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "All Items for updation",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('food_items').get(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            List<Widget> allItems = [];
            snapshot.data!.docs.forEach((element){
              if(element.id!='sample') allItems.add(foodItemTileMaker(element.id,element.get("name"), element.get("imageURL"), element.get("price"),screenWidth));
            });
            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
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
