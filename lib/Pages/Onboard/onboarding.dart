import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pups/Pages/Login/login.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFDBD2FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Container(
            height: MediaQuery.of(context).size.height, // Adjust to fit your design
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Container(
                    child: Image.asset(
                      'assets/onboard.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20), // Optional padding for aesthetics
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: w * 0.09,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Paws',
                        style: TextStyle(
                          fontSize: w * 0.09,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6A5ACD),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, -10), // Adjust the Y offset to move it up
                              child: Icon(
                                Icons.pets,
                                color: Color(0xFF7A6ED6),
                                size: 20,
                              ),
                            ),
                            Icon(
                              Icons.pets,
                              color: Color(0xFF7A6ED6),
                              size: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'Effortlessly book grooming for  ',
                                  style: TextStyle(
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'your pets and let them shine with care!',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 40), // Optional spacing before the button
                      Center(
                        child: ElevatedButton(
                          child: Text(
                            'Unleash the Love!',
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
                          onPressed: () {
                            Get.offAll(Login());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

        ),
      ),
    );
  }
}
