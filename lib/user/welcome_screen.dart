import 'package:flutter/material.dart';
import 'package:food_hut/screens/admin/admin_home.dart';
import 'package:food_hut/screens/admin/auth/admin_auth.dart';
import 'package:food_hut/screens/user/auth.dart';
class WelcomeScreen extends StatefulWidget {
  static const id = "/welcome";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight*0.3),
        child: AppBar(
          backgroundColor: Colors.cyan,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: screenHeight*0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 10),
                  child: Text(
                      "Welcome to",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth*0.13
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                      "Food Hut",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth*0.11
                    ),
                  ),
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: screenWidth,
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminAuthScreen()));
            },
            child: Container(
              height: screenHeight*0.055,
              width: screenWidth*0.8,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: screenHeight*0.1,bottom: 10),
              decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)
              ),
              child: Text(
                  "Continue as admin",
                style: TextStyle(
                  fontFamily: "SFpro",
                  fontSize: screenWidth*0.05
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthScreen()));
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
                "Continue as user",
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
