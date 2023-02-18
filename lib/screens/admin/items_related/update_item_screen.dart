import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
class UpdateItemScreen extends StatefulWidget {
  String docID;
  String itemName;
  int price;
  String imageURL;

  UpdateItemScreen({required this.docID, required this.itemName, required this.price, required this.imageURL});

  @override
  _UpdateItemScreenState createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  File? imageFile;
  final formKey = GlobalKey<FormState>();
  final TextEditingController postDescpController = TextEditingController();
  bool updatingItem = false;
  bool makeOutOfStock = false;

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
    itemNameController.text = widget.itemName;
    itemPriceController.text = widget.price.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Update Item Info.",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
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
          ),
          Center(
            child: GestureDetector(
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
                  child: imageFile==null ? Image.network(widget.imageURL) : Image.file(imageFile!,fit: BoxFit.cover,),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
              child: TextFormField(
                controller: itemPriceController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Item name" ,
                  hintText: "Samosa",
                ),
              ),
            ),
          ),
          Center(
            child: CheckboxListTile(
                value: makeOutOfStock,
                onChanged: (value){
              setState(() {
                makeOutOfStock=value!;
              });
                },
              title: Text("Declare Out Of stock"),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  updatingItem=true;
                });
                String imageURL;
                if(imageFile!=null){
                  imageURL = await uploadImage();
                  FirebaseStorage.instance.refFromURL(widget.imageURL).delete();
                }
                else{
                  imageURL = widget.imageURL;
                }

                FirebaseFirestore.instance.collection("food_items").doc(widget.docID).update({"name" : itemNameController.text.trim(),"price":int.parse(itemPriceController.text.trim()), "imageURL" : imageURL,"outOfStock" : makeOutOfStock});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item info updated")));
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
                  "Save the updates",
                  style: TextStyle(
                      fontFamily: "SFpro",
                      fontSize: screenWidth*0.05
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
