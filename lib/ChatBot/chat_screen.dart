import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gdsc/apiKey.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/screens/Donate/donation_confirmed.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Chat extends StatefulWidget {

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isLoading = false;
  var _gemini;
  @override
  void initState() {
    // TODO: implement initState
    loadGemini();
    super.initState();
  }

  void loadGemini() async {
    setState(() {
      _isLoading = true;
    });
    final config = GenerationConfig(
      temperature: 0.5,
      maxOutputTokens: 1000,
      topP: 1.0,
      topK: 40,
      stopSequences: []
    );
    final user = FirebaseAuth.instance.currentUser;
    final gemini = GoogleGemini(
      apiKey: ApiKey.api_key_gemini,
      config: config
    );
    setState(() {
      _gemini = gemini;
      _isLoading = false;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            ));
  }
}
