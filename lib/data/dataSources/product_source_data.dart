import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_e_commerce_app/auth/models/userModel.dart';
import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/data/models/my_order.dart';

import '../models/product.dart';

class ProductSourceData {
  Firebaseservices _firebaseservices=Firebaseservices();
  final db = FirebaseFirestore.instance;
  static String orderCollection="order";
  static String customersCollection="customers";
  static String cartCollection="cart";
  Future<List<Product>> getAllProducts()async{
    return await db.collection("products").get().then((value) => value.docs.map((e)=>Product.fromJson(e.data())).toList(),);
  }
  List<Product> shoesProducts(List<Product> list){
    List<Product> shoes=[];
    for(int i=0;i<list.length;i++){
      if(list[i].isShoes==true){
          shoes.add(list[i]);
      }
    }
    return shoes;
  }

  List<Product> favouriteProduct(List<Product> list){
    List<Product> favourite=[];
    for(int i=0;i<list.length;i++){
      if(list[i].isFavourite==true){
          favourite.add(list[i]);
      }
    }
    return favourite;
  }
  List<Product> bagsProducts(List<Product> list){
    List<Product> shoes=[];
    for(int i=0;i<list.length;i++){
      if(list[i].isBags==true){
          shoes.add(list[i]);
      }
    }
    return shoes;
  }
  List<Product> clothesProducts(List<Product> list){
    List<Product> favourite=[];
    for(int i=0;i<list.length;i++){
      if(list[i].isClothes==true){
          favourite.add(list[i]);
      }
    }
    return favourite;
  }
  List<Product> electronicsProducts(List<Product> list){
    List<Product> shoes=[];
    for(int i=0;i<list.length;i++){
      if(list[i].isElectronics==true){
          shoes.add(list[i]);
      }
    }
    return shoes;
  }
  Future<void> removeProductInCart(String id)async{
    await _firebaseservices.removeProductInCart(id);
  }
  Future<List<CartItem>> getAllCartProducts()async{
    return await _firebaseservices.getAllCartProducts();
  }
  Future<List<CartItem>> getAllOrderProducts()async{
    return await _firebaseservices.getAllOrderProducts();
  }
  Future<String> addCartProduct(Product product,int quantity)async{
    try {
      CartItem cart=CartItem(name: product.name, price: product.price, image: product.image, quantity: quantity, rating: product.rating);
      return await _firebaseservices.addtoCart(cart,product.id.toString());
        } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<String> addOrderProduct(MyOrder order)async{
    try {
      return await _firebaseservices.addtoOrder(order);
        } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Future<List<CartItem>> onGoingOrders() async{
  // List<CartItem> items=[];
  //   var list =await getAllOrderProducts();
  //   for (var i = 0; i < list.length; i++) {
  //     if(list[i].isPending=="Ongoing"){
  //       items.addAll(list[i].items);
  //       print(items);
  //     }
  //   }
  //   return items;
  // }
  Future<List<CartItem>> OnGoingOrders() async{
    List<CartItem> order=[];
  List<String> data=[];
  UserModel? user=await _firebaseservices.getCurrentUser();
    if(user==null){
      throw Exception("User is Not Authenticated");
    }
    var items =await db
    .collection(customersCollection)
    .doc(user.id)
    .collection(orderCollection)
    .get();
    items.docs.forEach((element){
       if(element.data()["isPending"]=="Ongoing"){
         List<dynamic> items=element.data()['items'];
         order.addAll(items.map((e) => CartItem.fromJson(e,user.id),).toList());
       }
       });
    return order;
  }
  Future<List<CartItem>> completedOrders() async{
    List<CartItem> order=[];
  List<String> data=[];
  UserModel? user=await _firebaseservices.getCurrentUser();
    if(user==null){
      throw Exception("User is Not Authenticated");
    }
    var items =await db
    .collection(customersCollection)
    .doc(user.id)
    .collection(orderCollection)
    .get();
    items.docs.forEach((element){
       if(element.data()["isPending"]=="completed"){
         List<dynamic> items=element.data()['items'];
         order.addAll(items.map((e) => CartItem.fromJson(e,user.id),).toList());
       }
       });
    return order;
  }
}