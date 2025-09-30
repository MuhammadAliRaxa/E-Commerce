import 'package:flutter/widgets.dart';

class PageViewState {
  final int index;
  final PageController controller;
  PageViewState({required this.controller,required this.index});

  PageViewState copyWith({
    int? index,
    PageController? controller,
  }) {
    return PageViewState(
      index: index ?? this.index,
      controller: controller ?? this.controller,
    );
  }
}
