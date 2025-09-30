import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';
import 'package:flutter_e_commerce_app/widget/product_details.dart';
import 'package:flutter_e_commerce_app/widget/products.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:searchable_listview/resources/arrays.dart';
import 'package:searchable_listview/widgets/search_text_field.dart';

class SearchField extends StatefulWidget {
  final List<Product> list;
  final String? hintText;
  final bool searchByCategory;
  
  const SearchField({
    required this.list,
    this.hintText = 'Search',
    this.searchByCategory = false,
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allProducts = widget.list;
    _filteredProducts = _allProducts;
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          bool matchesName = product.name.toLowerCase().contains(query);
          
          return matchesName;
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredProducts = _allProducts;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _searchController.text.isNotEmpty
                              ? 'Showing ${_filteredProducts.length} results for "${_searchController.text}"'
                              : 'Showing all ${_filteredProducts.length} products',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (widget.searchByCategory)
                        Chip(
                          label: const Text('Category search enabled'),
                          backgroundColor: Colors.blue[50],
                          labelStyle: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredProducts.isEmpty && _searchController.text.isNotEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return _productgrid(_filteredProducts[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productgrid(Product product,int index){
    return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(settings: RouteSettings(name: "product",arguments:  product),builder: (context) => ProductDetails(),));
              },
              child: AnimationConfiguration.staggeredList(
                duration: const Duration(milliseconds: 300),
                position:index ,
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
                                        height: 200,
                                        width: 150,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 194, 192, 191),
                                                borderRadius: BorderRadius.circular(25),
                                                image: DecorationImage(fit: BoxFit.fitWidth,image: NetworkImage(product.image))),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 5,
                                                child: IconButton(onPressed: (){
                                                  setState(() {
                                                    if(product.isFavourite==false){
                                                        product.isFavourite=true;
                                                    }else{
                                                      product.isFavourite=false;
                                                    }
                                                  });
                                                }, icon: Icon(product.isFavourite?Icons.favorite_rounded:Icons.favorite_outline_outlined)))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 1,child: Row(
                                  children: [
                                    Text(product.name,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                  ],
                                )),
                                Expanded(flex: 1,child: Row(
                                  children: [
                                    Icon(Icons.star_half_outlined),
                                    Text(product.rating.toString())
                                  ],
                                )),
                                Expanded(flex: 1,child: Row(
                                  children: [
                                    Text("Rs.${product.price}",style: TextStyle(
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
            );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear),
            label: const Text('Clear Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}