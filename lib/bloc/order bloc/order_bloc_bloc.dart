import 'package:bloc/bloc.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/data/repoositries/product_repositry.dart';
import 'package:meta/meta.dart';

part 'order_bloc_event.dart';
part 'order_bloc_state.dart';

class OrderBlocBloc extends Bloc<OrderBlocEvent, OrderBlocState> {
  final ProductRepositry productSourceData=ProductRepositry();
  
  // Keep track of current data
  List<CartItem> _ongoingOrders = [];
  List<CartItem> _completedOrders = [];

  OrderBlocBloc() : super(OrderBlocInitial()) {
    
    on<FetchOrderEvent>((event, emit) async {
      if (_ongoingOrders.isEmpty && _completedOrders.isEmpty) {
        emit(OrderLoadingState());
      }
      
      try {
        _ongoingOrders = await productSourceData.getOnGoingOrderProducts();
        emit(OrderLoadedState(
          ongoingItems: _ongoingOrders,
          completedItems: _completedOrders,
        ));
      } catch (e) {
        emit(OrderErrorState(message: e.toString()));
      }
    });

    on<FetchCompletedOrderEvent>((event, emit) async {
      if (_ongoingOrders.isEmpty && _completedOrders.isEmpty) {
        emit(OrderLoadingState());
      }
      
      try {
        _completedOrders = await productSourceData.getCompletedOrderProducts();
        emit(OrderLoadedState(
          ongoingItems: _ongoingOrders,
          completedItems: _completedOrders,
        ));
      } catch (e) {
        emit(OrderErrorState(message: e.toString()));
      }
    });
    on<RefreshOrdersEvent>((event, emit) async {
      emit(OrderLoadingState());
      
      try {
        final results = await Future.wait([
          productSourceData.getOnGoingOrderProducts(),
          productSourceData.getCompletedOrderProducts(),
        ]);
        
        _ongoingOrders = results[0];
        _completedOrders = results[1];
        
        emit(OrderLoadedState(
          ongoingItems: _ongoingOrders,
          completedItems: _completedOrders,
        ));
      } catch (e) {
        emit(OrderErrorState(message: e.toString()));
      }
    });
  }
}

