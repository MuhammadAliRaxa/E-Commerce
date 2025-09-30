part of 'shipping_address_bloc.dart';
class ShippingAddressState {
  String homeAddress;
  ShippingAddress address;
  ShippingAddressState(this.address,this.homeAddress);
}

class ShippingAddressInitial extends ShippingAddressState {
  String homeAddress;
  ShippingAddress shipping;
  ShippingAddressInitial(this.shipping,this.homeAddress) : super(shipping,homeAddress);
}

class SelectShippingAddress extends ShippingAddressState{
  String homeAddress;
  ShippingAddress shipping;
  SelectShippingAddress(this.shipping,this.homeAddress) : super(shipping,homeAddress);
}
