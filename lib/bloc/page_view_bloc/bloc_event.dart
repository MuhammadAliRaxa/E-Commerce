import 'package:flutter/cupertino.dart';
@immutable
class PageViewEvent{
  const PageViewEvent();
}
@immutable
class ChangeIndexEvent extends PageViewEvent{
  final int index;
  const ChangeIndexEvent({required this.index});
}