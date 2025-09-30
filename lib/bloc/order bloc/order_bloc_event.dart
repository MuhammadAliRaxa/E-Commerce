part of 'order_bloc_bloc.dart';

@immutable
sealed class OrderBlocEvent {

}
class FetchOrderEvent extends OrderBlocEvent{

}

class FetchCompletedOrderEvent extends OrderBlocEvent{

}

class RefreshOrdersEvent extends OrderBlocEvent {
  
} 

