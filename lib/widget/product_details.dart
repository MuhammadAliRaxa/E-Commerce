import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/product_bloc/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/product_bloc/bloc_state.dart';
import 'package:flutter_e_commerce_app/bloc/product_bloc/product_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    String msg="Done";
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    var Size(height:height,width:width)=MediaQuery.sizeOf(context);
    return Scaffold(
      body: BlocConsumer<ProductBloc,ProductState>(
        listener: (context, state) {
          if(state is AddToCartState){
            msg =state.message;
          }
        },
        bloc: context.watch<ProductBloc>(),
        builder: (context, state) =>SafeArea(
          child: Container(
            color: const Color.fromARGB(232, 190, 187, 179),
            child: Column(
              children: [
             SizedBox(
              height: height*0.45,
                width: width,
               child: Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(fit: BoxFit.fill,image: NetworkImage(product.image)),
                ),
               ),
             ),
             Padding(
              padding:EdgeInsets.all(5),
               child: AnimationConfiguration.staggeredList(
                position: 0,
                 child: SlideAnimation(
                  duration: Duration(seconds: 1),
                  verticalOffset: 800,
                   child: Container(
                    height: height*0.50,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(40) ,topRight: Radius.circular(40))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 15,
                        children: [
                          Padding(padding: EdgeInsets.all(5)),
                          AnimationConfiguration.staggeredList(
                            position: 1,
                            duration:const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Row(
                                  children: [
                                    Expanded(flex:8,child: SizedBox(child: Text(product.name,style: TextStyle(fontSize: 20),))),
                                    Expanded(flex:2,child:Align(alignment: Alignment.centerRight,child:IconButton(onPressed: (){
                                      if(product.isFavourite==true){
                                        product.isFavourite=false;
                                      }else{
                                        product.isFavourite==true;
                                      }
                                    },icon:Icon(product.isFavourite?Icons.favorite_rounded:Icons.favorite_outline_outlined)),))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 2,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              horizontalOffset: 100,
                              child: FadeInAnimation(
                                child: Align(alignment: Alignment.centerLeft,child: Row(
                                  children: [
                                    Icon(Icons.star_half_rounded),
                                    Text(product.rating.toString(),style: TextStyle(fontSize: 15),),
                                  ],
                                )),
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black45,
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 3,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              verticalOffset: 100,
                              child: FadeInAnimation(
                                child: Align(alignment: Alignment.bottomLeft
                                ,child: Text("Description",style:TextStyle(fontSize: 20),)),
                              ),
                            ),
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 4,
                            child: SlideAnimation(
                              verticalOffset: 100,
                              child: FadeInAnimation(
                                child: Text(product.description??"Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                style: TextStyle(fontSize: 13),),
                              ),
                            ),
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 5,
                            child: SlideAnimation(
                              verticalOffset: 100,
                              child: FadeInAnimation(
                                child: Row(
                                  spacing: 20,
                                  children: [
                                    Text("Quantity",style: TextStyle(fontSize: 20),),
                                    Container(width: 150,height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)
                                      ,color: const Color.fromARGB(232, 190, 187, 179),
                                    ),
                                    child: Row(
                                      children: [
                                         Expanded(flex: 2,child: TextButton(onPressed: (){
                                          context.read<ProductBloc>().add(const DecreamentProductQuantityEvent());
                                         }, child: Text('-',style: TextStyle(fontSize: 20,)))),
                                         Expanded(flex: 2,child: Align(alignment: Alignment.center,child: Text(state.quantity.toString(),style: GoogleFonts.anta(fontSize: 16),))),
                                         Expanded(flex: 2,child: TextButton(onPressed: (){
                                          context.read<ProductBloc>().add(const IncreamentProductQantityEvent());
                                         }, child: Text("+",style: TextStyle(fontSize: 20),)))
                                      ],
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                            
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black45,
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 6,
                            child: FadeInAnimation(
                              child: SlideAnimation(
                                verticalOffset: 100,
                                child: Row(
                                  spacing: 25,
                                  children: [
                                    Column(
                                      children: [
                                        Text("total Price",style: TextStyle(fontSize: 14,color: Colors.black26),),
                                        Text("Rs.${product.price}",style: TextStyle(fontSize: 20),)
                                      ],
                                    ),
                                    Expanded(
                                      flex:7,
                                      child: SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: ElevatedButton(style: ButtonStyle(backgroundColor:WidgetStateColor.resolveWith((states) => Colors.black,)),onPressed: ()async{
                                          context.read<ProductBloc>().add(AddToCartEvent(product: product,quantity: state.quantity,context: context));
                                            await Future.delayed(const Duration(seconds: 1));
                                            Fluttertoast.showToast(msg: msg,
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16
                                );
                                        }, child:Text("Add to Cart",style: TextStyle(fontSize: 20,color: Colors.white),)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                   ),
                 ),
               ),
             ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}