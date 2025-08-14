import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Custom Chat App",
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> _messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
void _sendMessage() {
  String message = _controller.text.trim();
  if (message.isEmpty) return;

  setState(() {
    _messages.add({"message": message, "isSentByMe": true});
    _isTyping = true;
  });

  _controller.clear();
  _scrollToBottom();

  Timer(Duration(seconds: 2), () {
    setState(() {
      _isTyping = false;
      _messages.add({
        "message": "Your friend's auto-generated reply",
        "isSentByMe": false,
      });
      _scrollToBottom();
    });
  });
}

void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Chat App")),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ChatBubble(
                message: _messages[index]["message"],
                isSentByMe: _messages[index]["isSentByMe"],
              );
            },
          ),
        ),
        if (_isTyping)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your friend is typing...",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter a message...",
                    border: OutlineInputBorder(),
                  ),
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    ),
     );
 }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  ChatBubble({required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isSentByMe ? Radius.circular(15) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}