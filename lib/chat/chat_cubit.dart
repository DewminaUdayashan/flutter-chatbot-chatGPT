import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_screen.dart';
import '../services.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final TextEditingController textEditingController;
  ChatCubit(this.textEditingController) : super(const ChatingState());

  void sendMessage() async {
    /// clear `textEditingController`
    textEditingController.clear();

    /// create message model
    ChatMessage message = ChatMessage(
      text: textEditingController.text,
      sender: "Me",
      time: DateTime.now(),
    );

    /// get older message list from state
    /// if it is `null`, it's mean this is new chat
    List<ChatMessage> messages = (state as ChatingState).messages ?? [];

    /// insert user's message to the list
    messages.add(message);

    /// this model is used to store reply message. until response receive,
    /// this will make a loading effect on chat
    messages
        .add(ChatMessage(text: '...', sender: 'Chatty', time: DateTime.now()));

    /// emit user's message to the state & set as loading the reply
    emit((state as ChatingState).copyWith(
      messages: messages,
      isLoading: true,
    ));
    try {
      final replyFromAI = await ChatGPTAPI().getMessage(message.text);
      ChatMessage reply = ChatMessage(
        text: replyFromAI.choices?.first.message?.content ?? "",
        sender: "Chatty",
        time: DateTime.now(),
      );
      messages = (state as ChatingState).messages ?? [];
      messages.removeLast();
      messages.add(reply);

      /// emit the reply
      emit((state as ChatingState).copyWith(
        messages: messages,
        isLoading: false,
      ));
    } catch (e) {
      ChatMessage error = ChatMessage(
        text: e.toString(),
        sender: "Error Bot",
        time: DateTime.now(),
      );
      messages.removeLast();
      messages.add(error);
      emit((state as ChatingState).copyWith(
        messages: messages,
        isLoading: false,
      ));
    }
  }
}
