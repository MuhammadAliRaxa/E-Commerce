part of 'help_chat_bloc.dart';

@immutable
sealed class HelpChatState {
  bool isLoading; 
  final List<Map<String,dynamic>> messages;
  HelpChatState({required this.isLoading,required this.messages});
}

final class HelpChatInitial extends HelpChatState {
  HelpChatInitial({required super.messages, required super.isLoading});
}
final class HelpChatLoading extends HelpChatState {
  HelpChatLoading({required super.messages, required super.isLoading});
}
final class HelpChatLoaded extends HelpChatState {
  HelpChatLoaded({required super.messages, required super.isLoading});
}