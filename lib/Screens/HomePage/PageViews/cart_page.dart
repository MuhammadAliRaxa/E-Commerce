
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/Screens/cartPayments%20Page/checkout_page.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/bloc_state.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/cart_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:flutter_e_commerce_app/widget/cart_product_details.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartProduct());
  }
  
  @override
  Widget build(BuildContext context) {
    var Size(:height,:width)=MediaQuery.of(context).size;
    return  Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shopping_cart),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<CartBloc,CartState>(
        bloc: context.watch<CartBloc>(),
        builder: (context, state) => switch(state) {
          CartInitialState() => InitialWidget(),
          CartLoadingState() => LoadingWidget(),
          CartLoadedState(CartProducts:var products)  => LoadedWidget(products: products,state: state,),
          CartErrorState(error:var err) => Container(
            color: Colors.red
            ,child: Text(err.toString()),
          ),
          CartState() => InitialWidget(),
        },
      ),
      backgroundColor: Colors.white10,
    );
  }
} 
class LoadedWidget extends StatelessWidget {
  final List<CartItem> products;
  final CartState state;
  const LoadedWidget({required this.state,required this.products,super.key});

  @override
  Widget build(BuildContext context) {
    var Size(:height,:width)=MediaQuery.of(context).size;
    return Scaffold( 
      bottomNavigationBar: Container(
        width: width,
        height: height*0.08,
        color: Colors.white,
        child: AnimationConfiguration.staggeredList(
                      position: 2,
                      child: FadeInAnimation(
                        child: SlideAnimation(
                          horizontalOffset: 100,
                          child: Row(
                            spacing: 25,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  
                                  children: [
                                    Expanded(flex: 5,child: Align(alignment: Alignment.center,child: Text("Total Price",style: TextStyle(fontSize: 18,color: Colors.black26),))),
                                    Expanded(flex: 5,child: Align(alignment: Alignment.center,child: Text("Rs.${state.total}.00",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex:7,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 50,
                                    width: 250,
                                    child: ElevatedButton(style: ButtonStyle(backgroundColor:WidgetStateColor.resolveWith((states) => Colors.black,)),onPressed: (){
                                      if(products.length!=0){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckoutScreen(cartItems: products,),));
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cart is Empty")));
                                      }
                                    }, child: Text("Checkout", style: TextStyle(fontSize: 20,color: Colors.white),)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
      ),
     body: products.length==0?InitialWidget():Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(itemCount:products.length ,itemBuilder: (parent, index)=>
            CartProductDetails(product:products[index])
            ),
          ));
  }
}
class InitialWidget extends StatelessWidget {
  const InitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("No Products Added"),
    );
  }
}
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator()
    );
  }
}