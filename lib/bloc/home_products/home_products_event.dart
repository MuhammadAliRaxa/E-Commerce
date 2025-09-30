part of 'home_products_bloc.dart';

@immutable
sealed class HomeProductsEvent {}

class FetchProducts extends HomeProductsEvent{}
class FetchShoes extends HomeProductsEvent{}
class FetchClothes extends HomeProductsEvent{}
class FetchBags extends HomeProductsEvent{}
class FetchElectronics extends HomeProductsEvent{}
class FetchFavourites extends HomeProductsEvent{}