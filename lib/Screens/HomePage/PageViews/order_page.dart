import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/order%20bloc/order_bloc_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch both types of orders
    context.read<OrderBlocBloc>().add(FetchOrderEvent());
    context.read<OrderBlocBloc>().add(FetchCompletedOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.read<OrderBlocBloc>().add(RefreshOrdersEvent());
          },
          icon: const Icon(Icons.refresh, color: Colors.black, size: 24),
        ),
        title: const Text('My Orders',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Ongoing'), Tab(text: 'Completed')],
        ),
      ),
      body: BlocBuilder<OrderBlocBloc, OrderBlocState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Ongoing Orders Tab
              _buildTabContent(state, isOngoing: true),
              // Completed Orders Tab  
              _buildTabContent(state, isOngoing: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent(OrderBlocState state, {required bool isOngoing}) {
    switch (state) {
      case OrderBlocInitial():
        return _buildEmptyState();
      case OrderLoadingState():
        return _buildLoading();
      case OrderLoadedState():
        final items = isOngoing ? state.ongoingItems : state.completedItems;
        return items.isEmpty 
            ? _buildEmptyState() 
            : _buildOrdersList(items,isOngoing);
      case OrderErrorState():
        return _buildErrorState(state.message);
      default:
        return _buildEmptyState();
    }
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message'),
          ElevatedButton(
            onPressed: () {
              context.read<OrderBlocBloc>().add(RefreshOrdersEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<CartItem> orders,bool isGoing) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(order,isGoing),
        );
      },
    );
  }

  Widget _buildOrderCard(CartItem order,bool isGoing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              order.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGoing?"In Delivery":'Delivered',
                      style: TextStyle(
                        fontSize: 12, 
                        color: isGoing
                            ? Colors.orange 
                            : Colors.green,
                      ),
                    ),
                    Text(
                      'Rs.${(int.tryParse(order.price) ?? 0) * order.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No orders found"),
    );
  }
}