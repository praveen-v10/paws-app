import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/Login/user_details.dart';
import 'package:pups/Pages/bottom.dart';
import 'package:pups/Pages/home.dart';
import 'package:pups/Widgets/loading.dart';

import 'Google_Connection.dart';

class Login extends StatefulWidget {
  static String userId = '';
  static String userEmail = '';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _Loading = false;

  // firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthMethods _authMethods = AuthMethods();

// new user or exist user check

  Future<bool> userAvailableFirestore() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: Login.userEmail)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  userCheck() async {
    bool onUserAvailable = await userAvailableFirestore();

    if (onUserAvailable == true) {
      await getDocumentID();
      print('User available');

    } else {

      Get.to(UserDetails());
      print('not available');
    }
  }

  getDocumentID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: Login.userEmail)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
        snapshot.docs.forEach((f) async {
          print("documentID---- " + f.reference.id);

          await Hive.openBox("UserDetails");
          var box = Hive.box('UserDetails');
          box.put('user_id', f.reference.id);

        }),
      },
    );

    Get.offAll(Bottom());
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return _Loading?DefaultLoading():Scaffold(
      backgroundColor : Color(0xFFD1C6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Container(
                 height: h * 0.5,
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                       child: Image.asset(
                         'assets/onboard.png',
                         width: MediaQuery.of(context).size.width * 0.5,
                       ),
                     ),
                     Transform.translate(
                       offset: Offset(0, 0),
                       child: Text(
                         'PAWS',
                         style: TextStyle(
                           fontSize: w * 0.09,
                           fontWeight: FontWeight.w900,
                           color: Color(0xFF6A5ACD),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),


               Container(
                 height: h * 0.5,
                 width: w,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(20),
                     topRight: Radius.circular(20),

                   ),
                 ),

                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Padding(
                       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                       child: Text('Continue caring for your pets with just a tap',style: TextStyle(fontSize: w*0.08,fontWeight: FontWeight.w500,),  textAlign: TextAlign.center,),

                     ),

                     ElevatedButton.icon(
                       icon: Image.asset(
                         'assets/google.png', // Google logo asset
                         height: 30,
                         width: 30,
                       ),
                       label: Text(
                         'Start with Google',
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                       style: ElevatedButton.styleFrom(
                         primary: Color(0xFF6A5ACD), // Google blue color
                         onPrimary: Colors.white, // Text and icon color
                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30), // Rounded button
                         ),
                       ),
                       onPressed: () async {
                         setState(() {
                           _Loading = true;
                         });
                         bool result = await _authMethods.signInWithGoogle();
                         print('Google Login $result');
                         final User? user = auth.currentUser;
                         final uid = user?.uid;
                         final email=user?.email;
                         print("$uid Current user uid...");

                         if(result==false){
                           setState(() {
                             _Loading = false;
                           });
                         }
                         setState(() {
                           Login.userEmail = email!;
                         });

                         await userCheck();

                         setState(() {
                           _Loading = false;
                         });
                       },
                     ),

                     Padding(
                       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Terms Conditions',style: TextStyle(color: Colors.blueAccent),),
                           Text('Privacy Policy',style: TextStyle(color: Colors.blueAccent)),
                         ],
                       ),
                     )

                   ],
                 ),

               )
          
          
          

             ],
           ),
          ),
        ),
      ),
    );
  }
}
