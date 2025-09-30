import 'package:flutter/cupertino.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';

@immutable
class ProductEvent{
  const ProductEvent();
}
@immutable
class AddToCartEvent extends ProductEvent{
  final Product product;
  final int quantity;
  final BuildContext context;
  const AddToCartEvent({required this.context,required this.quantity,required this.product});
}
@immutable
class IncreamentProductQantityEvent extends ProductEvent{
   const IncreamentProductQantityEvent();
}
@immutable
class DecreamentProductQuantityEvent extends ProductEvent{
  const DecreamentProductQuantityEvent();
}
