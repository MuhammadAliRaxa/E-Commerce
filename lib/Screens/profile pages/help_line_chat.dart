import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/help%20line%20chat/help_chat_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<HelpChatBloc>().add(HelpChatEvent(userInput: text));
      _controller.clear();
      _scrollToBottom();
    }
  }

  List<Map<String, dynamic>> _getMessages(HelpChatState state) {
    if (state is HelpChatInitial) {
      return state.messages;
    } else if (state is HelpChatLoaded) {
      return state.messages;
    } else if (state is HelpChatLoading) {
      return state.messages ?? [];
    }
    return [];
  }

  bool _isLoading(HelpChatState state) {
    return state is HelpChatLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help Line Chat")),
      body: BlocConsumer<HelpChatBloc, HelpChatState>(
        listener: (context, state) {
          // Auto-scroll when new messages arrive
          if (state is HelpChatLoaded) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          final messages = _getMessages(state);
          final isLoading = _isLoading(state);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    
                    if (isLoading && index == messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container( 
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SpinKitThreeBounce(color: Colors.black54,size: 16,)
                            ],
                          ),
                        ),
                      );
                    }

                    final msg = messages[index];
                    final isUser = msg["role"] == "user";

                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.blue[200]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg["content"] ?? "",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    );
                  },
                ),
              ),
              

              // Input field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        enabled: !isLoading, // Disable while loading
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          hintText: "Ask your Help Line Agent...",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isLoading ? null : _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}