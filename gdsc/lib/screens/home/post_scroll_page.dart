import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gdsc/palette.dart';
import 'package:google_fonts/google_fonts.dart';

FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in physical pixels (px)
Size size = view.physicalSize;
double width = size.width;
double height = size.height;

// // Dimensions in logical pixels (dp)
// Size size = view.physicalSize / view.devicePixelRatio;
// double width = size.width;
// double height = size.height;

class PostScrollPage extends StatefulWidget {
  const PostScrollPage({super.key});

  @override
  State<PostScrollPage> createState() => _PostScrollPageState();
}

class _PostScrollPageState extends State<PostScrollPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/target_image_1.jpeg',
            fit: BoxFit.contain,
            width: width,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.usb_rounded,
              ),
              Icon(
                Icons.comment,
              )
            ],
          ),
        ],
      )
    ]));
  }
}
