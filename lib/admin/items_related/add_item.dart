import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class AddFoodItem extends StatefulWidget {
  const AddFoodItem({Key? key}) : super(key: key);

  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  File? imageFile;
  final formKey = GlobalKey<FormState>();
  final TextEditingController postDescpController = TextEditingController();
  bool uploadingNewItem = false;
  Future<void> pickImage() async {
    //bool check = await _permission.isGranted;
    print("HELLO");
    // print(check.toString() + " Hello");
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("YES #");
    if (pickedImage == null) return;
    setState(() {
      print(pickedImage.path);
      imageFile = File(pickedImage.path);
    });
  }

  Future<String> uploadImage() async {
    final destination = itemNameController.text.trim() + itemPriceController.text.trim();
    var ref = FirebaseStorage.instance.ref(destination);
    try{
      await ref.putFile(imageFile!);
      print("YES1");
      String imageURL = await FirebaseStorage.instance.ref(destination).getDownloadURL();
      print(imageURL);
      return imageURL;
    }
    on Firebase catch (error){
      return "upload failed !";
    }
  }

  Widget screenToShowOnAddingItem(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text("Adding new item..."),
        ],
      ),);
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Add Item",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: uploadingNewItem==true ? screenToShowOnAddingItem() : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
            child: TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Item name" ,
                  hintText: "Samosa",
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              pickImage();
            },
            child: Container(
              height: screenWidth * 0.9,
              width: screenWidth * 0.9,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: GestureDetector(
                onTap: (){
                  pickImage();
                },
                child: imageFile==null ? Container(
                  child: Center(child: Text("Click to pick an image"),),
                ) : Image.file(imageFile!,fit: BoxFit.cover,),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
            child: TextFormField(
              controller: itemPriceController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter item price" ,
                hintText: "40",
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                uploadingNewItem=true;
              });
              String imageURL = await uploadImage();
              FirebaseFirestore.instance.collection("food_items").doc(itemNameController.text.trim()).set({"name" : itemNameController.text.trim(),"price":int.parse(itemPriceController.text.trim()), "imageURL" : imageURL,"outOfStock" : false});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New food item added")));
              Navigator.pop(context);
            },
            child: Container(
              height: screenHeight*0.055,
              width: screenWidth*0.8,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black)
              ),
              child: Text(
                "Add this item",
                style: TextStyle(
                    fontFamily: "SFpro",
                    fontSize: screenWidth*0.05
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     setState(() {
          //       uploadingNewItem=true;
          //     });
          //     String imageURL = await uploadImage();
          //     FirebaseFirestore.instance.collection("food_items").doc(itemNameController.text.trim()).set({"name" : itemNameController.text.trim(),"price":int.parse(itemPriceController.text.trim()), "imageURL" : imageURL,"outOfStock" : false});
          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New food item added")));
          //     Navigator.pop(context);
          //   },
          //   child: Text("Add this item"),
          // )
        ],
      ),
    );
  }
}
