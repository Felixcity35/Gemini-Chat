import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:untitled/constant.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = []; // Stores chat messages
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  late GenerativeModel model;

  @override
  void initState() {
    model = GenerativeModel(
        // For text-only input, use the gemini-pro model
        model: 'gemini-pro',
        apiKey: apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: 100));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sendMessage(String text) async {
      setState(() {
        isLoading = true;
      });
      var content = Content.text(_textController.text.toString());
      var response = await model.startChat().sendMessage(content);
      setState(() {
        if (kDebugMode) {
          print('response is $response');
        }
        messages.add(_textController.text.toString());
        messages.add(response.text.toString());
        _textController.clear();
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          (messages.isNotEmpty)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          messages[index],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      );
                    },
                  ),
                )
              : const Expanded(
                  child: Center(
                      child: Text(
                    "Chat is Empty",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
                ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController,
                    decoration:
                        const InputDecoration(hintText: 'Type your message'),
                  ),
                ),
              ),
              IconButton(
                icon: (isLoading)
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: () => sendMessage(_textController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
