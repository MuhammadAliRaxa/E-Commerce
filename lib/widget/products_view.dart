import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';
import 'package:flutter_e_commerce_app/widget/products.dart';

class ProductsView extends StatelessWidget {
  final String name;
  final List<Product> products;
  const ProductsView({required this.name,required this.products,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(name,style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),),
          ),
          Products(productList: products)
        ],
      ),
    );
  }
}