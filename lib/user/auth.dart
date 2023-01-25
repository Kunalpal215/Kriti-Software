import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home/main_user_screen.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool signingIn = true;
  bool buttonPressed = false;
  var timer = null;

  Widget onSigningInOrSigningUp (String emailSent,var screenWidth){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: screenWidth,),
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(top: 15,left: 40,right: 40),
              child: Text(signingIn==true ? "Signing In..." : "Verify yourself through verification email sent to email : ${emailSent}",
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

  Widget LoginPart(var screenWidth, var screenHeight){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter email" ,
              hintText: "xyz@abc.com",
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
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
    );
  }

  Widget SignUpPart(var screenWidth, var screenHeight){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
          child: TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter username" ,
              hintText: "Kunalpal215",
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter email" ,
              hintText: "xyz@abc.com",
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
            signingIn=false;
            UserCredential userCred;
            try{
              userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
              await userCred.user!.sendEmailVerification();
              print("HELLO 1");
              var count = 0;
              timer = Timer.periodic(Duration(seconds: 3), (timer) async {
                print(count);
                count+=3;
                await FirebaseAuth.instance.currentUser!.reload();
                if(FirebaseAuth.instance.currentUser!.emailVerified){
                  print("NO");
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).set({"username" : usernameController.text.trim(),"cart":[],"hasOrder":false,"orderNumber" : -1});
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              });
            }
            on FirebaseAuthException catch(e){
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
              "Sign Up",
              style: TextStyle(
                  fontFamily: "SFpro",
                  fontSize: screenWidth*0.05
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    super.dispose();
    if(timer!=null){
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: buttonPressed==true ? onSigningInOrSigningUp(emailController.text.trim(),screenWidth) : Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffF2F2F2),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight*0.35),
          child: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              margin: EdgeInsets.only(top: screenHeight*0.12,bottom: screenHeight*0.08),
                child: Image.asset("assets/app_icon.jpg",)
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Text(
                      "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "SFpro",
                      fontSize: screenWidth*0.05
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Sign-up",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "SFpro",
                        fontSize: screenWidth*0.05
                    ),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            LoginPart(screenWidth, screenHeight),
            SignUpPart(screenWidth, screenHeight)
          ],
        )
      ),
    );
  }
}
