import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({Key? key}) : super(key: key);

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  late String _verificationId = '';

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = '+91' + _phoneNumberController.text.trim();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Navigate to next screen upon successful verification
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextScreen()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Error: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        // Navigate to the OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              verificationId: _verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text.trim(),
    );
    try {
      await _auth.signInWithCredential(credential);
      // Navigate to next screen upon successful verification
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NextScreen()),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We will send you one time password',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color.fromARGB(255, 112, 110, 110),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'for your mobile number',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color.fromARGB(255, 112, 110, 110),
                ),
              ),
              SizedBox(height: 60.0),
              Text(
                'Enter mobile number',
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: TextField(
                  decoration: InputDecoration(
                    // hintText: 'Enter phone number',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(14),
                    PhoneNumberFormatter()
                  ],
                ),
              ),
              SizedBox(height: 60.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    child: Text(
                      'Get OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 6, 97, 171)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final List<String> digits =
        newValue.text.replaceAll(RegExp(r'\D'), '').split('');

    final StringBuffer newText = StringBuffer();

    // Append country code
    if (digits.length > 0) {
      newText.write('+${digits[0]}');
      if (digits.length > 3) newText.write(' ');
    }

    for (int i = 1; i < digits.length; i++) {
      if (i == 4) newText.write(' ');
      newText.write(digits[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class OtpVerificationPage extends StatelessWidget {
  final String verificationId;

  const OtpVerificationPage({Key? key, required this.verificationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement OTP verification logic here
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('You have successfully logged in!'),
      ),
    );
  }
}
