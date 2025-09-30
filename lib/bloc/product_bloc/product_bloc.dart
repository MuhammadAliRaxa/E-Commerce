import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/product_bloc/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/product_bloc/bloc_state.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/cart_page.dart';

import '../../data/repoositries/product_repositry.dart' show ProductRepositry;

class ProductBloc extends Bloc<ProductEvent,ProductState>{
  ProductRepositry repositry=ProductRepositry();
  ProductBloc():super(InitialState(isFavourite: false, quantity: 1)){
    on<IncreamentProductQantityEvent>((event, emit) {
      emit(ProductState(quantity: state.quantity+1, isFavourite: state.isFavourite));
    },);
    on<DecreamentProductQuantityEvent>((event, emit) {
        if(state.quantity>1){
        emit(ProductState(quantity:state.quantity-1, isFavourite: state.isFavourite,));
        }
    },);
    on<AddToCartEvent>((event, emit)async {
       try {
        String a =await repositry.addProductInCart(event.product,event.quantity);
        emit(AddToCartState(message: a, isFavourite: state.isFavourite, quantity: state.quantity));
       } catch (e) {
         emit(ErrorState(error: e.toString(), quantity: state.quantity, isFavourite: state.isFavourite));
       }
    },);
  }
}