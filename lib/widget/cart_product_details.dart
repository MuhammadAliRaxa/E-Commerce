import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/counter_quantity/bloc_state.dart';
import 'package:flutter_e_commerce_app/bloc/counter_quantity/quantity_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/widget/bottomSheetforDelete.dart';
import 'package:google_fonts/google_fonts.dart';

class CartProductDetails extends StatelessWidget {
  final CartItem product;
  const CartProductDetails({required this.product,super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuantityBloc,QuantityState>(
      bloc: context.watch<QuantityBloc>(),
      builder: (context, state) => Padding(
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
                                Expanded(flex: 2,child: Builder(
                                  builder: (context) => IconButton(onPressed: (){
                                      showModalBottomSheet(
                                        constraints: BoxConstraints.tight(Size(double.infinity,320)),
                                        context: context,
                                        enableDrag: true,
                                         elevation: 100,
                                         isDismissible: true,
                                        showDragHandle: true,
                                        builder: (context) {
                                          return DeleteBottomSheet(product: product,);
                                        },
                                      );
                                  }, icon: Icon(Icons.delete_rounded)),
                                ),
                                )
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
                                Expanded(
                                  flex: 4,
                                  child: Container(width: 70,height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30)
                                        ,color: const Color.fromARGB(232, 190, 187, 179),
                                      ),
                                      child: Row(
                                        children: [
                                           Expanded(flex: 2,child: TextButton(onPressed: (){
                                            //context.read<QuantityBloc>().add(const DecreamentQuantityEvent());
                                           }, child: Text('-',style: TextStyle(fontSize: 10,)))),
                                           Expanded(flex: 2,child: Align(alignment: Alignment.center,child: Text(product.quantity.toString(),style: GoogleFonts.anta(fontSize: 8),))),
                                           Expanded(flex: 2,child: TextButton(onPressed: (){
                                              //context.read<QuantityBloc>().add(IncreamentQantityEvent());
                                              product.quantity=state.count;
                                           }, child: Text("+",style: TextStyle(fontSize: 10),)))
                                        ],
                                      ),),
                                )
                              ],
                            ),
                          )
                      ],
                    ))
                ],
              ),
            ),
          ),
      ),
    );
  }
}