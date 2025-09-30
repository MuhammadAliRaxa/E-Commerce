class QuantityState{
  String? address;
  final int count;
  QuantityState({this.address,required this.count});
}
class HomeAddressState extends QuantityState{
  HomeAddressState({required super.count,required super.address});
}