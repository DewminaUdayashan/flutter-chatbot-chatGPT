import 'package:chatty/chat/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget _buildTextComposer() {
    return Builder(builder: (context) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: context.read<ChatCubit>().textEditingController,
                keyboardType: TextInputType.multiline,
                decoration:
                    const InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => context.read<ChatCubit>().sendMessage(),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatingState) {
            return Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) =>
                        (state.messages?.isEmpty ?? true)
                            ? const SizedBox.shrink()
                            : ChatItem(
                                chatMessage:
                                    state.messages?.reversed.toList()[index] ??
                                        ChatMessage(
                                          text: '',
                                          sender: '',
                                          time: DateTime.now(),
                                        ),
                              ),
                    itemCount: state.messages?.reversed.toList().length,
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String sender;
  final DateTime time;

  const ChatMessage(
      {required this.text, required this.sender, required this.time});
}

class ChatItem extends StatelessWidget {
  final ChatMessage chatMessage;
  const ChatItem({super.key, required this.chatMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(chatMessage.sender[0])),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(chatMessage.sender,
                    style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(chatMessage.text),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: Text(
              "${chatMessage.time.hour}:${chatMessage.time.minute}",
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
