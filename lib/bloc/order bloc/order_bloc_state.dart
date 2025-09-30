part of 'order_bloc_bloc.dart';

@immutable
sealed class OrderBlocState {}
@immutable
final class OrderBlocInitial extends OrderBlocState{

}
@immutable
final class OrderLoadingState extends OrderBlocState{

}
@immutable
class OrderLoadedState extends OrderBlocState {
  final List<CartItem> ongoingItems;
  final List<CartItem> completedItems;
  
  OrderLoadedState({
    required this.ongoingItems,
    required this.completedItems,
  });
}
class OrderErrorState extends OrderBlocState {
  final String message;
  OrderErrorState({required this.message});
}