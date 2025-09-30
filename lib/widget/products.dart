import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';
import 'package:flutter_e_commerce_app/widget/product_details.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Products extends StatefulWidget {
  final List<Product> productList;
  const Products({required this.productList,super.key});

  @override
  State<Products> createState() => _ProductsState();
}
class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.73,
            mainAxisSpacing: 30,
            crossAxisSpacing: 15,
            crossAxisCount: 2), delegate: SliverChildBuilderDelegate(childCount: widget.productList.length,(context, index) => 
            
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(settings: RouteSettings(name: "product",arguments:  widget.productList[index]),builder: (context) => ProductDetails(),));
              },
              child: AnimationConfiguration.staggeredList(
                duration: const Duration(milliseconds: 300),
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                            height: 250,
                            width: 150,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 194, 192, 191),
                                                borderRadius: BorderRadius.circular(25),
                                                image: DecorationImage(fit: BoxFit.contain,image: NetworkImage(widget.productList[index].image))),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 5,
                                                child: IconButton(onPressed: (){
                                                  setState(() {
                                                    if(widget.productList[index].isFavourite==false){
                                                        widget.productList[index].isFavourite=true;
                                                    }else{
                                                      widget.productList[index].isFavourite=false;
                                                    }
                                                  });
                                                }, icon: Icon(widget.productList[index].isFavourite?Icons.favorite_rounded:Icons.favorite_outline_outlined)))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 1,child: Row(
                                  children: [
                                    Text(widget.productList[index].name,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                  ],
                                )),
                                Expanded(flex: 1,child: Row(
                                  children: [
                                    Icon(Icons.star_half_outlined),
                                    Text(widget.productList[index].rating.toString())
                                  ],
                                )),
                                Expanded(flex: 1,child: Row(
                                  children: [
                                    Text("Rs.${widget.productList[index].price}",style: TextStyle(
                                      fontSize: 16,fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                ))
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
                 ),
              )
    );
  }
}