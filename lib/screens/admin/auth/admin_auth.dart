import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_hut/screens/admin/admin_home.dart';
class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({Key? key}) : super(key: key);

  @override
  _AdminAuthScreenState createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool buttonPressed = false;

  Widget onSigningIn(var screenWidth){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: screenWidth,),
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(top: 15,left: 40,right: 40),
            child: Text("Signing In...",
              style: TextStyle(
                  fontFamily: "SFpro",
                  fontSize: 18
              ),
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
    return buttonPressed==true ? onSigningIn(screenWidth) : Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
            "Admin Authentication",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Column(
        children: [
          Image.asset("assets/auth_key.png",width: screenWidth*0.6,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter email" ,
                hintText: "xyz@abc.com"
                ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter password" ,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                buttonPressed=true;
              });
              UserCredential userCred;
              try{
                userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
                DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admin').doc("auth_emails").get();
                bool check = adminSnapshot.get("emails").contains(emailController.text.trim());
                if(check==false){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No such admin exists")));
                  setState(() {
                    buttonPressed=false;
                  });
                  return;
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHome()));
              }
              on FirebaseAuthException catch (e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
                setState(() {
                  buttonPressed=false;
                });
              }
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
                "Login",
                style: TextStyle(
                    fontFamily: "SFpro",
                    fontSize: screenWidth*0.05
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
