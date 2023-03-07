import 'package:chatty/services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmit(String text) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      sender: "Me",
      time: DateTime.now(),
    );
    setState(() {
      _messages.insert(0, message);
    });
    final replyFromAI = await ChatGPTAPI().getMessage(text);
    ChatMessage reply = ChatMessage(
      text: replyFromAI.choices?.first.message?.content ?? "",
      sender: "AI",
      time: DateTime.now(),
    );
    setState(() {
      _messages.insert(0, reply);
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmit(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;
  final DateTime time;

  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(sender[0])),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(sender, style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: Text(
              "${time.hour}:${time.minute}",
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
