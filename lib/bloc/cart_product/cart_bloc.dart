import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/bloc_state.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/data/repoositries/product_repositry.dart';

class CartBloc extends Bloc<CartEvent, CartState>{
  ProductRepositry repositry=ProductRepositry();
  CartBloc():super(CartState(total: 0)){
    on<FetchCartProduct>((event, emit) async {
      emit(CartLoadingState(total: state.total));
      try {
        var products=await repositry.getAllCartProducts();
        emit(CartLoadedState(CartProducts: products,total: total(products)));

      } catch (e) {
        emit(CartErrorState(error: e.toString()));
      }
    },);
    on<DeleteCartProductEvent>((event, emit) async{
      try {
        await repositry.removeCartProduct(event.product);
      } catch (e) {
        emit(CartErrorState(error: e.toString()));
      }
    },);
  }
  int total(List<CartItem> list){
    int t=0;

     for (var i = 0; i < list.length; i++) {
       t+=int.parse(list[i].price)*list[i].quantity;
     }
     return t;
  }
}