import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/Booking/booking.dart';
import 'package:pups/Pages/Onboard/onboarding.dart';
import 'package:pups/Pages/home.dart';

import '../Pages/bottom.dart';

class SplashScreen extends StatefulWidget {
  static String selectedImage = '';
  static Color selectedColor='' as Color ;

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  List<String> images = [
    'assets/profile1.jpg',
    'assets/profile2.jpg',
    'assets/profile3.jpg',
    'assets/profile4.jpg',
    'assets/profile5.jpg',
  ];

  final List<Color> serviceColors = [
    Color(0xFFA0CBFE),
    Color(0xFFCCF9B8),
    Color(0xFFFFC8EF),
    Color(0xFFB4E6FF),
    Color(0xFFB0F8E0),
    Color(0xFFD1C6FF),
  ];


  @override
  void initState() {
    super.initState();

    initialization();
  }

  void selectRandomImage() {
    // Generate a random index based on the length of the images list
    final randomIndex = Random().nextInt(images.length);
    final randomColor = Random().nextInt(serviceColors.length);
    setState(() {

      SplashScreen.selectedImage = images[randomIndex];
      SplashScreen.selectedColor = serviceColors[randomColor];
    });
    print(SplashScreen.selectedColor);
  }


  void initialization() async {

    await Hive.openBox("UserDetails");
    var box = Hive.box('UserDetails');
    var userId = box.get('user_id');

    selectRandomImage();
    print('Splash Screen Started...');
    await Future.delayed(const Duration(seconds: 2));

    if(userId==null){
      Get.offAll(OnBoarding());
    }else{
      Get.offAll(Bottom());
    }
    print('Splash Screen Loading Done...');



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFD1C6FF),
        child: Center(
          child: Image.asset('assets/splash_logo.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
