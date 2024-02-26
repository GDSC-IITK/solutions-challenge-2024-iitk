import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/ChatBot/message.dart';
import 'package:gdsc/apiKey.dart';

import 'package:google_gemini/google_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

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
        stopSequences: []);

    final user = FirebaseAuth.instance.currentUser;
    final gemini = GoogleGemini(
      apiKey: ApiKey.api_key_gemini,
      // config: config
    );
    setState(() {
      _gemini = gemini;
      _isLoading = false;
    });
  }

  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Message> msgs = [];
  bool isTyping = false;
  String prompt = '''
Imagine a chatbot that serves as the intelligent heart of Feed Harmony, guiding users through the process of donating food, volunteering for deliveries, and even navigating the complexities of the hunger crisis. This chatbot, let's call it Harmony Helper, is not just a tool but a companion in the journey towards ending hunger. Powered by Gemini AI, it's designed to provide comprehensive support, answer questions, and offer insights on all matters related to food donation, distribution, and the broader context of hunger and food insecurity.

Prompt for Gemini AI to Create Harmony Helper:

"Create a chatbot named Harmony Helper for the Feed Harmony app, which aims to alleviate hunger through a community-driven approach to food donation and distribution. Harmony Helper should be equipped to handle a wide array of queries ranging from logistical questions about how to donate food, where to deliver it, and how the food distribution process works, to educational content about the hunger crisis and how individuals can make a difference.

This chatbot should be able to:

Guide Users: Provide step-by-step instructions for new donors and volunteers on how to use the app, including how to post surplus food, accept a delivery task, and navigate to the suggested drop-off locations.
Predictive Suggestions: Use the underlying predictive ML model to suggest beneficiary locations for volunteers, explaining the reasoning behind these suggestions based on k-means and DBscan algorithms.
Incentive Information: Explain the incentive mechanisms in place for active participants, detailing how milestones are tracked and rewards are allocated.
Educational Content: Offer information on the hunger crisis, including statistics, causes, and the impact of food waste. It should also provide tips on how to reduce food waste and how donated food makes a difference.
Troubleshooting Support: Assist users with common issues or questions they might have while using the app, from technical problems to questions about food safety standards for donations.
Community Engagement: Encourage users to share their experiences and photos of their food donation activities, fostering a sense of community and inspiring others to join the initiative.
Feedback Collection: Collect user feedback on app functionality and user experience, offering a direct line for suggestions on how to improve Feed Harmony.
Integrate Harmony Helper seamlessly into the Feed Harmony app, ensuring it reflects the app's mission to connect food donors with volunteers seamlessly, making a meaningful impact on the lives of homeless and vulnerable populations. The chatbot should embody the values of compassion, community, and innovation, making every interaction informative, supportive, and inspiring
For short questions, write in breif and do not over feed the user with lots of data. Now the question of the user is this 
''';
  void sendMsg() {
    FocusScope.of(context).unfocus();

    if (controller.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please ask your question to begin'),
        ),
      );
      return;
    }
    setState(() {
      msgs.insert(0, Message(true, controller.text));
      _isLoading = true;
      isTyping = true;
    });
    controller.clear();

    _gemini.generateFromText(prompt + controller.text).then((value) {
      setState(() {
        msgs.insert(0, Message(false, value.text!));
        isTyping = false;
        print(value.text);
      });
      controller.clear();
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Harmony Helper",
              style: TextStyle(fontSize: 23),
            ),
            const Text(
              "presented by Gemini",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          msgs.length == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(29.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Disclaimer',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'about the chatbot',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          textAlign: TextAlign.start,
                          'The content within this app is generated by Gemini AI. We want to make it clear that we do not claim ownership of the content produced by the AI. The developers are not responsible for the accuracy, completeness, or appropriateness of the generated content. Gemini can make mistakes. Consider checking important information.By continuing to use this app, you acknowledge and accept these terms.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: msgs.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: isTyping && index == 0
                          ? Column(
                              children: [
                                BubbleNormal(
                                  text: msgs[0].msg,
                                  isSender: true,
                                  color: Colors.blue.shade100,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Gemini is typing...")),
                                )
                              ],
                            )
                          : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: !msgs[index]
                                        .isSender, // Show only if isSender is false
                                    child: Container(
                                      child: CircleAvatar(
                                        child: ImageIcon(
                                          AssetImage('assets/Icons/gemini.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: BubbleNormal(
                                      text: msgs[index].msg,
                                      isSender: msgs[index].isSender,
                                      color: msgs[index].isSender
                                          ? Colors.blue.shade100
                                          : Colors.grey.shade200,
                                    ),
                                  ),
                                ],
                              ),
                          ));
                }),
          ),
          Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Choose your desired color
                  width: 1, // Choose your desired width
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Container(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            controller: controller,
                            textCapitalization: TextCapitalization.sentences,
                            onSubmitted: (value) {
                              sendMsg();
                            },
                            textInputAction: TextInputAction.send,
                            showCursor: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter text"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () {
                          sendMsg();
                        },
                  child: Opacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ImageIcon(
                        AssetImage("assets/Icons/chat.png"),
                        // color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
