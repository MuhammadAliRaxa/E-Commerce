import 'package:bloc/bloc.dart';
import 'package:flutter_e_commerce_app/auth/services/ai_service.dart';
import 'package:meta/meta.dart';

part 'help_chat_event.dart';
part 'help_chat_state.dart';

class HelpChatBloc extends Bloc<HelpChatEvent, HelpChatState> {
  final _ai =SmartAIService();
  HelpChatBloc() : super(HelpChatInitial(isLoading: false,messages: [
    {
      "role": "assistant", "content":"Hey, how can i help you today." 
    }
  ])) {
    on<HelpChatEvent>((event, emit) async{
      final text = event.userInput;
    if (text.isEmpty) return;
      state.messages.add({"role": "user", "content": text});
      state.isLoading=true;
      emit(HelpChatLoading(isLoading: true, messages: state.messages));
      final reply = await _ai.chat(text);
      state.messages.add({"role": "assistant", "content": reply});
      state.isLoading = false;
      emit(HelpChatLoaded(isLoading: false, messages: state.messages));
    });
  }
}
