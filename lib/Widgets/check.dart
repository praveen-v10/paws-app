import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSlotUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Row(
            children: [
              // First time slot with the clock icon and time in blue background
              ClipPath(
                clipper: ArrowClipper(),
                child: Container(
                  height: 100,
                  width: 200,
                  color: Colors.blue,

                  child:   Center(
                    child: Text(
                      'Today, Jul 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // Second time slot with time and date in white background
              Container(
                height: 100,

                child: Center(
                  child: Text(
                    '4:30 PM',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom clipper to create the arrow shape
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}