// Stack(
//   children: [
//     // Your existing page content
//     Positioned.fill(
//       child: Opacity(
//         opacity: 0.8, // Adjust opacity for desired transparency
//         child: Container(
//           color: Colors.black, // Or desired background color
//         ),
//       ),
//     ),
//     // Your animation widget
//     Center(
//       child: AnimatedOpacity(
//         opacity: showAnimation ? 1.0 : 0.0,
//         duration: Duration(milliseconds: 300),
//         child: Lottie.asset("assets/your_animation.json"),
//       ),
//     ),
//   ],
// ),


// TextButton(
//   onPressed: () {
//     setState(() {
//       showAnimation = true;
//     });
//   },
//   child: Text("Show Animation"),
// ),