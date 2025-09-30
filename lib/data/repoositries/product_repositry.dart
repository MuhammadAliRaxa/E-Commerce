import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_e_commerce_app/data/dataSources/product_source_data.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/data/models/my_order.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';

class ProductRepositry {
  static ProductSourceData resourceData=ProductSourceData();

  Future<List<Product>> getAllProducts(){
    return resourceData.getAllProducts();
  }
  List<Product> shoesProducts(List<Product> list){
    return resourceData.shoesProducts(list);
  }
  List<Product> favouriteProducts(List<Product> list){
    return resourceData.favouriteProduct(list);
  }
  List<Product> bagsProducts(List<Product> list){
    return resourceData.bagsProducts(list);
  }
  List<Product> clothesProducts(List<Product> list){
    return resourceData.clothesProducts(list);
  }
  List<Product> electronicsProducts(List<Product> list){
    return resourceData.electronicsProducts(list);
  }
  Future<String> addProductInCart(Product product,int quantity)async{
   return await resourceData.addCartProduct(product,quantity);
  }
  Future<String> addProductInOder(MyOrder order)async{
   return await resourceData.addOrderProduct(order);
  }
  Future<List<CartItem>> getAllCartProducts(){
    return resourceData.getAllCartProducts();
  }
  Future<List<CartItem>> getOnGoingOrderProducts(){
    return resourceData.OnGoingOrders();
  }
  Future<List<CartItem>> getCompletedOrderProducts(){
    return resourceData.completedOrders();
  }
   Future<void> removeCartProduct(String product)async{
    await resourceData.removeProductInCart(product);
  }
}