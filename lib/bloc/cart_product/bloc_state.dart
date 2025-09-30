import 'package:flutter_e_commerce_app/data/models/cart_product.dart';

class CartState{
  final int total;
  const CartState({required this.total});
}
class CartInitialState extends CartState{
  CartInitialState({required super.total});
}
class CartLoadingState extends CartState{
  CartLoadingState({required super.total});
}
class CartLoadedState extends CartState{
  final List<CartItem> CartProducts;
  const CartLoadedState({required this.CartProducts,required super.total});
}
class CartErrorState extends CartState{
  final String error;
  const CartErrorState({required this.error}) : super(total: 0);
}