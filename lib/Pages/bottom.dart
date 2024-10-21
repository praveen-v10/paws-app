import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:pups/Pages/Appointment/appointment.dart';
import 'package:pups/Pages/Booking/pet_select.dart';
import 'package:pups/Pages/Profile/profile.dart';
import 'package:pups/Pages/home.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
 late int currentIndex = 0;

  final List<Widget> pages = [
    Home(),
    Appointment(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: Stack(
        children: [
          // Display the current page
          pages[currentIndex],
          Positioned(
            bottom: 14,
            left: size.width * 0.3,
            right:size.width * 0.3,
            child: Container(
              height: size.height * 0.06,
              width: size.width * 0.3,
              decoration: BoxDecoration(
                color: Color(0xFFF3F3F3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = index; // Update the current index
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: size.height * 0.05,
                        width: size.height * 0.05,
                        decoration: BoxDecoration(
                            color: currentIndex == index
                                ? Color(0xFF7A6ED6)
                                : Colors.white,
                          borderRadius: BorderRadius.circular(50)
                        ),

                        child:  Center(
                          child: Icon(
                            listOfIcons[index],
                            size: size.width * 0.065,
                            color: currentIndex == index
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    )
                  );
                }),
              )
            ),
          ),
        ],
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.calendar_month, // Icon for Booking History
    Icons.person_rounded,
  ];
}

