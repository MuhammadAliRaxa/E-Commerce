
class ProductState{
  bool isFavourite;
  int quantity;
  ProductState({required this.isFavourite,required this.quantity});
  ProductState copyWith({
    bool? isFavourite,
    int? quantity,
  }) {
    return ProductState(
      isFavourite: isFavourite ?? this.isFavourite,
      quantity: quantity ?? this.quantity,
    );
}
}
class AddToCartState extends ProductState{
  final String message;
  AddToCartState({required this.message,required super.isFavourite, required super.quantity});
}
class ErrorState extends ProductState{
  final String error;
  ErrorState({required this.error,required super.isFavourite, required super.quantity});
}
class InitialState extends ProductState{
  InitialState({required super.isFavourite, required super.quantity});

}
