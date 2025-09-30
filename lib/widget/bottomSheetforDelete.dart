
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/cart_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteBottomSheet extends StatelessWidget {
  final CartItem product;
  const DeleteBottomSheet({required this.product,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(flex: 1,child: Text("Remove from Cart ?", style : TextStyle(fontSize: 22))),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black12,
          ),
          Expanded(flex: 4,child: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            height: 140,
        
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child:Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(232, 190, 187, 179),
                        image: DecorationImage(image: NetworkImage(product.image))
                      ),
                    ) 
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                      spacing: 10,
                      children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(flex: 8,child: SizedBox(child: Text(product.name,style: TextStyle(fontSize: 20),))),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Icon(Icons.star_half_outlined),
                                Text(product.rating.toString())
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(flex: 5,child: Text("Rs.${product.price}",)),
                                
                              ],
                            ),
                          )
                      ],
                    ))
                ],
              ),
            ),
          ),
      )),
      Container(
        width: double.infinity,
        height: 1,
        color: Colors.black12,),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(flex: 5,child: Padding(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(style: ButtonStyle(backgroundColor:WidgetStateColor.resolveWith((states) =>  const Color.fromARGB(232, 190, 187, 179),) ),onPressed: (){
                
                  }, child: Text("Cancel",style: TextStyle(fontSize: 15,color: Colors.white),)),
                ),
              )),
              Expanded(flex: 5,child: Padding(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(style: ButtonStyle(backgroundColor:WidgetStateColor.resolveWith((states) =>  Colors.black,) ),onPressed: ()async{
                    context.read<CartBloc>().add(DeleteCartProductEvent(product: product.id!));
                    await Future.delayed(Duration(milliseconds: 500));
                    context.read<CartBloc>().add(FetchCartProduct());
                    Navigator.of(context).pop();
                  }, child: Text("Yes, Remove",style: TextStyle(fontSize: 15,color: Colors.white),)),
                ),
              ))
            ],
          ),
        )
        ],
      ),
    );
  }
}