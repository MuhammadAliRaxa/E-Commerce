import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/bloc/page_view_bloc/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/page_view_bloc/bloc_state.dart';

class PageViewBloc extends Bloc<PageViewEvent,PageViewState>{
    PageViewBloc():super(PageViewState(index: 0,controller: PageController(initialPage: 0))){
      on<ChangeIndexEvent>((event, emit) {
        state.controller.jumpToPage(event.index);
        emit(state.copyWith(index: event.index,controller: state.controller));
      },);
    }
    @override
  Future<void> close() {
    state.controller.dispose();
    return super.close();
  }
}
