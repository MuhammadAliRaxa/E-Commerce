part of 'shipping_address_bloc.dart';

sealed class ShippingAddressEvent {
}
class ChangeShippingAddressEvent extends ShippingAddressEvent{
  String homeAddress;
  ShippingAddress address;
  ChangeShippingAddressEvent(this.address,this.homeAddress);
}
class ChangeHomeAddress extends ShippingAddressEvent{
  String Address;
  ChangeHomeAddress({required this.Address});
}
