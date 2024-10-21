import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/bottom.dart';
import 'package:pups/Pages/home.dart';

import '../../Widgets/loading.dart';
import '../../Widgets/splash_screenn.dart';
import '../Login/login.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controllerEmail = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerName = TextEditingController();

  bool loading=false;


  @override
  void initState() {
    super.initState();
    controllerEmail.text = Home.userEmail;
    controllerPhone.text = Home.userPhone;
    controllerName.text = Home.userName;
  }



  updateUserDetails() async {
    setState(() {
      loading=true;
    });
    await Hive.openBox("UserDetails");
    var box = Hive.box('UserDetails');
    var userId = box.get('user_id');

    try{
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'userName': controllerName.text,
        'userPhone': controllerPhone.text,
        'userEmail': controllerEmail.text,
      });



      setState(() {
        loading=false;
      });

    } catch(e){
      setState(() {
        loading=false;
      });
      Fluttertoast.showToast(msg: 'Please try again',  gravity: ToastGravity.CENTER,);

    }

  }


  updateEmail() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('can not signOut as : $e');
    }
    var box = Hive.box('UserDetails');
    await box.deleteAll(box.keys);

  }

  Future<bool> emailAvailableFirestore() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: controllerEmail.text)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  emailCheck() async {
    bool onEmailAvailable = await emailAvailableFirestore();

    if (onEmailAvailable == true) {

      Fluttertoast.showToast(msg: 'This Email Already Exist',gravity: ToastGravity.CENTER);

    } else {
      updateConfirmation();

    }
  }


  void updateConfirmation() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          backgroundColor: Colors.white, // Set the background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Add rounded corners
          ),
          title: Center(
            child: const Text(
              "Update Profile Confirmation",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ), // Make the title bold
            ),
          ),
          content: SingleChildScrollView( // Wrap Column with SingleChildScrollView
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Set a fixed width for the dialog (80% of screen width)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Image.asset('assets/update.png')
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Updating your email requires you to log in again with the new email to access your data.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10), // Add some spacing between the texts
                  Text(
                    'Do you want to proceed?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space evenly between buttons
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey, // A soft purple to complement the background
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Add padding for a better touch target
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Rounded corners for a modern look
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Get.offAll(Bottom());
                  },
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Increase font size for better visibility
                        fontWeight: FontWeight.bold, // Make the text bold for emphasis
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Optional: Add space between the buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6A5ACD), // A soft purple to complement the background
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Add padding for a better touch target
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Rounded corners for a modern look
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await updateUserDetails();
                    await updateEmail();
                    Get.offAll(Login());
                  },
                  child: Center(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Increase font size for better visibility
                        fontWeight: FontWeight.bold, // Make the text bold for emphasis
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return loading?DefaultLoading():Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: SplashScreen.selectedColor,
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(24), // Optional: add padding for spacing
            decoration: BoxDecoration(
              color: SplashScreen.selectedColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Ensures the height is only as tall as content
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Home.userName.replaceFirst(
                      Home.userName[0], Home.userName[0].toUpperCase()),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(height: 10), // Optional: add spacing between texts
                Text(
                  Home.userPhone,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(height: 10), // Optional: add spacing between texts
                Text(
                  Home.userEmail,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ],
            ),
          ),
        ),

      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: GestureDetector(
          onTap: () {
           // updateConfirmation();

            showModalBottomSheet(
              isScrollControlled: true, // Allows the bottom sheet to expand with the keyboard
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for the keyboard
                      ),
                      child: Stack(
                        clipBehavior: Clip.none, // Allow elements to be positioned outside the container
                        children: [
                          Container(
                            //height: MediaQuery.of(context).size.height * 0.5, // Adjust height dynamically
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: SplashScreen.selectedColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView( // Wrap content with SingleChildScrollView
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    child: Text(
                                      'Update Your Details',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                          child: TextField(
                                            controller: controllerName,
                                            autocorrect: false,
                                            autofocus: false,
                                            onChanged: (value) {
                                              setState(() {
                                                // Calculate the new cursor position based on the removed character index
                                                int cursorPosition = controllerName.selection.baseOffset;
                                                if (cursorPosition > 0 && value.length < controllerName.text.length) {
                                                  cursorPosition--;
                                                }

                                                // Update the text and cursor position
                                                controllerName.text = value;
                                                controllerName.selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
                                              });

                                           print( controllerName.text);
                                            },
                                            style: TextStyle(fontSize: 16),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54, width: 1),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54, width: 1),
                                              ),
                                              hintText: 'Name',
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
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
                                                // Calculate the new cursor position based on the removed character index
                                                int cursorPosition = controllerPhone.selection.baseOffset;
                                                if (cursorPosition > 0 && value.length < controllerPhone.text.length) {
                                                  cursorPosition--;
                                                }

                                                // Update the text and cursor position
                                                controllerPhone.text = value;
                                                controllerPhone.selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
                                              });


                                            },
                                            style: TextStyle(fontSize: 16),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54, width: 1),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54, width: 1),
                                              ),
                                              hintText: 'Phone',
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                          child: TextField(
                                            controller: controllerEmail,
                                            autocorrect: false,
                                            autofocus: false,
                                            onChanged: (value) {
                                              setState(() {
                                                // Calculate the new cursor position based on the removed character index
                                                int cursorPosition = controllerEmail.selection.baseOffset;
                                                if (cursorPosition > 0 && value.length < controllerEmail.text.length) {
                                                  cursorPosition--;
                                                }

                                                // Update the text and cursor position
                                                controllerEmail.text = value;
                                                controllerEmail.selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
                                              });



                                            },
                                            style: TextStyle(fontSize: 16),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54, width: 1),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54, width: 1),
                                              ),
                                              hintText: 'Email ID',
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 30,),
                                  GestureDetector(
                                    onTap: () async {

                                       if(controllerPhone.text.length != 10){
                                        Fluttertoast.showToast(msg: 'Please Enter Valid Phone Number',  gravity: ToastGravity.CENTER,);
                                      } else if(controllerEmail.text.isEmail == false){
                                         Fluttertoast.showToast(msg: 'Please Enter Valid Email Id',  gravity: ToastGravity.CENTER,);
                                       } else if( Home.userEmail != controllerEmail.text ){
                                         Navigator.pop(context);
                                         await emailCheck();
                                         print(controllerEmail.text.isEmail);
                                      } else {
                                         Navigator.pop(context);
                                        await updateUserDetails();
                                        Get.off(Bottom());
                                       }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFF6A5ACD),
                                      ),
                                      width: 300,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'Continue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18, // Increase font size for better visibility
                                            fontWeight:
                                            FontWeight.bold, // Make the text bold for emphasis
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -60, // Move the button upwards by setting a negative value
                            right: 10,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: SplashScreen.selectedColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 30,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF6A5ACD),
            ),
            width: 300,
            height: 50,
            child: Center(
              child: Text(
                'Change My Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Increase font size for better visibility
                  fontWeight:
                  FontWeight.bold, // Make the text bold for emphasis
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
