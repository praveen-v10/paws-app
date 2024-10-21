import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          height: 120,
          width: 120,
          child: Lottie.asset('assets/loading.json'),
        ),
      ),
    );
  }
}
