import 'package:flutter/material.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter OTP Code',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'OTP Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // for resending OTP
                  },
                  child: Text('Resend OTP'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    nextScreenReplace(context, HomePage());
                    // OTP verification
                  },
                  child: Text('Verify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
