// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatingState extends ChatState {
  final bool isLoading;
  final List<ChatMessage>? messages;

  const ChatingState({this.isLoading = false, this.messages});

  ChatingState copyWith({
    bool? isLoading,
    List<ChatMessage>? messages,
  }) {
    return ChatingState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [isLoading, messages ?? []];
}
