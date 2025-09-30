import 'package:flutter/foundation.dart';
@immutable
class QuantityEvent{
  const QuantityEvent();
}
@immutable
class IncreamentQantityEvent extends QuantityEvent{
   const IncreamentQantityEvent();
}
@immutable
class DecreamentQuantityEvent extends QuantityEvent{
  const DecreamentQuantityEvent();
}
class onAddressEvent extends QuantityEvent{
  final String address;
  const onAddressEvent({required this.address});
}