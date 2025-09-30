part of 'home_products_bloc.dart';

@immutable
class HomeProductsState {
  final bool isBag;
  final bool isShoes;
  final bool isClothes;
  final bool isAll;
  final bool isElectronics;
  const HomeProductsState({required this.isShoes,required this.isClothes,required this.isAll,required this.isElectronics,required this.isBag});
}

class HomeProductsInitial extends HomeProductsState {
 final UserModel user;
 const HomeProductsInitial({required this.user,required super.isShoes, required super.isClothes, required super.isAll, required super.isElectronics, required super.isBag});
  
}
class HomeProductsLoading extends HomeProductsState {
  const HomeProductsLoading({required super.isShoes, required super.isClothes, required super.isAll, required super.isElectronics, required super.isBag});
}
class HomeProductsLoaded extends HomeProductsState{
  final List<Product> products;
  const HomeProductsLoaded({required this.products,required super.isShoes, required super.isClothes, required super.isAll, required super.isElectronics, required super.isBag});
}
class HomeProductsError extends HomeProductsState {
  const HomeProductsError():super(isShoes: false, isClothes: false, isAll: false, isElectronics: false, isBag: false);
}
class UserData extends HomeProductsLoaded{
  UserModel user;
  UserData({required this.user,required super.products, required super.isShoes, required super.isClothes, required super.isAll, required super.isElectronics, required super.isBag});
  
}

