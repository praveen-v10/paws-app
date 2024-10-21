import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/Login/login.dart';
import 'package:pups/Pages/bottom.dart';
import 'package:pups/Pages/home.dart';
import 'package:uuid/uuid.dart';

import '../../Widgets/loading.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  final controllerEmail = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerName = TextEditingController();


  bool _Loading = false;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    controllerEmail.text = Login.userEmail;
  }



  addUserFirebase() async {

    String id = '';
    if (mounted) {
      setState(() {
        id = uuid.v4();
      });
    }

    await FirebaseFirestore.instance.collection('users').doc(id).set({
      'userId': id,
      'userName': controllerName.text,
      'userPhone': controllerPhone.text,
      'userEmail': Login.userEmail,

    });

    await Hive.openBox("UserDetails");
    var box = Hive.box('UserDetails');
    box.put('user_id', id);

    print('lllllllllllllllllllllllllllllllll');
    print(id);

    await Get.offAll(Bottom());
    print('22222222222222222222222222222');
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return _Loading
        ? DefaultLoading()
        : Scaffold(
            backgroundColor: Color(0xFFD1C6FF),
            body: SafeArea(
              child: SingleChildScrollView(
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
                              'PUPS',
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
                          SizedBox(height: 30,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text('Join us and make pet care a breeze from day one!',style: TextStyle(fontSize: w*0.05,fontWeight: FontWeight.w300,),  textAlign: TextAlign.center,),
                          ),
                          Container(
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                      child: TextButton(onPressed: () async {
                                        GoogleSignIn googleSignIn = GoogleSignIn();
                                        await googleSignIn.disconnect();
                                        await FirebaseAuth.instance.signOut();

                                        Navigator.pop(context);
                                      }, child: Text('Wrong Email?'))),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: TextField(
                                 controller: controllerName,
                                    autocorrect: false,
                                    autofocus: false,
                                    onChanged: (value) {
                                      setState(() {
                                       controllerName.text=value;
                                      });

                                    },
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        hintText: 'Name',
                                        hintStyle:
                                            TextStyle(color: Colors.grey.shade400)),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                   controller: controllerPhone,
                                    autocorrect: false,
                                    autofocus: false,
                                    onChanged: (value) {
                                      setState(() {
                                        controllerPhone.text=value;
                                      });
                                    },
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        hintText: 'Phone',
                                        hintStyle:
                                        TextStyle(color: Colors.grey.shade400)),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                  child: TextField(
                              controller: controllerEmail,
                                    autocorrect: false,
                                    autofocus: false,
                                    readOnly: true,
                                    onTap: (){
                                Fluttertoast.showToast(msg: 'Already verified');
                                    },
                                    // onChanged: (value) {
                                    //   setState(() {
                                    //     controllerEmail.text=value;
                                    //   });
                                    // },
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        hintText: 'Email ID',
                                        hintStyle:
                                        TextStyle(color: Colors.grey.shade400)),
                                  ),
                                ),
                              ],
                            ),
                          ),


                          SizedBox(height: 20,),
                          ElevatedButton(
                            child: Text(
                              'Start Caring Today!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18, // Increase font size for better visibility
                                fontWeight: FontWeight.bold, // Make the text bold for emphasis
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF6A5ACD), // A soft purple to complement the background
                              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12), // Add padding for a better touch target
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Rounded corners for a modern look
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _Loading=true;
                              });
                              await addUserFirebase();

                              setState(() {
                                _Loading=false;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
