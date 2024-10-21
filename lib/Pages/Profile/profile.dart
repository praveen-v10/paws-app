import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/Onboard/onboarding.dart';
import 'package:pups/Pages/Profile/edit_profile.dart';
import 'package:pups/Pages/Profile/faq.dart';
import 'package:pups/Pages/Profile/privacy_policy.dart';
import 'package:pups/Pages/Profile/support.dart';
import 'package:pups/Pages/Profile/terms_condition.dart';
import 'package:pups/Widgets/loading.dart';

import '../../Widgets/splash_screenn.dart';
import '../home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool loading=false;

  logOut() async {
    setState(() {
      loading=true;
    });

    var box = Hive.box('UserDetails');
    await box.deleteAll(box.keys);

    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      setState(() {
        loading=false;
      });
      print('can not signOut as : $e');
    }


    setState(() {
      loading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return loading?DefaultLoading():Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: SplashScreen.selectedColor,
        centerTitle: true,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip
                      .none, // To allow overflow of image outside the container
                  children: [
                    // The top container
                    Container(
                      height: h * 0.1,
                      width: w,
                      decoration: BoxDecoration(
                        color: SplashScreen.selectedColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),

                    // Positioned widget for the image container
                    Positioned(
                      top: h * 0.085 -
                          48, // Adjusting the position so half of the image stays inside
                      left: (w - 100) / 2, // Center the image horizontally
                      child: Container(
                        padding: EdgeInsets.all(4), // Border width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(48), // Image radius
                            child: Image.asset(SplashScreen.selectedImage,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  Home.userName.replaceFirst(Home.userName[0], Home.userName[0].toUpperCase()),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    width: w,
                    decoration: BoxDecoration(
                      color: SplashScreen.selectedColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                          Get.to(  EditProfile());
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(50)),
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Profile Details',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),

                          // Divider(endIndent: 16,indent: 16,),

                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.to(Support());
                            },
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 34,
                                        width: 34,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child:   Icon(
                                            CupertinoIcons.chat_bubble_text_fill,
                                            color: Colors.black54,
                                            size: 20,
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Support',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black54,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.to(FAQ());
                            },
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Container(
                                            height: 34,
                                            width: 34,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(50)),
                                            child: Center(
                                              child:   Icon(
                                                Icons.question_answer_rounded,
                                                color: Colors.black54,
                                                size: 20,
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'FAQ',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black54,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),



                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.to(PrivacyPolicyPage());
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(50)),
                                          child: Center(
                                            child:    Icon(
                                              Icons.privacy_tip_rounded,
                                              color: Colors.black54,
                                              size: 20,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Privacy Policy',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black54,
                                  size: 20,
                                )
                              ],
                            ),
                          ),


                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.to(TermsConditionsPage());
                            },
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Container(
                                            height: 34,
                                            width: 34,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(50)),
                                            child: Center(
                                              child:     Icon(
                                                Icons.policy_rounded,
                                                color: Colors.black54,
                                                size: 20,
                                              ),
                                            ),
                                          ),


                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Terms and Conditions',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black54,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await logOut();
                              Get.offAll(OnBoarding());
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(50)),
                                          child: Center(
                                            child:        Icon(
                                              Icons.logout_rounded,
                                              color: Colors.black54,
                                              size: 20,
                                            ),
                                          ),
                                        ),


                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Sign out',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black54,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
