import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/feed harmony.png'),
            Lottie.asset('assets/animations/start_animation.json',
            height: 150,
            repeat: false),
          ],
        ),
      ),
    );
  }
}
