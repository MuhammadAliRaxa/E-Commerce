import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/auth/models/userModel.dart';
import 'package:flutter_e_commerce_app/auth/services/firebaseServices.dart';
import 'package:flutter_e_commerce_app/bloc/home_products/home_products_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/product.dart';
import 'package:flutter_e_commerce_app/data/repoositries/product_repositry.dart';
import 'package:flutter_e_commerce_app/main.dart';
import 'package:flutter_e_commerce_app/widget/Catgories.dart';
import 'package:flutter_e_commerce_app/widget/Imageslider.dart';
import 'package:flutter_e_commerce_app/widget/products_view.dart';
import 'package:flutter_e_commerce_app/widget/products.dart';
import 'package:flutter_e_commerce_app/widget/search.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product>? wishlistProduct;
  bool isAll = true;
  bool isShoes = false;
  bool isClothes = false;
  bool isElectronics = false;
  bool isBags = false;
  TextEditingController searchController = TextEditingController();
  UserModel? user;
  @override
  void dispose() {
    searchController.dispose(); 
    super.dispose();
  }
  ProductRepositry _repo=ProductRepositry();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => 
      context.read<HomeProductsBloc>().add(FetchProducts()),
    );
    init();
  }
  void init() async {
     user=await _firebaseservices.getCurrentUser();
  }
  

  Firebaseservices _firebaseservices=Firebaseservices();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeProductsBloc, HomeProductsState>(
      bloc: context.watch<HomeProductsBloc>(),
      builder: (context, state){
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AnimationConfiguration.staggeredList(
                      position: 0,
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        horizontalOffset: 100,
                        child: FadeInAnimation(
                          child: ListTile(
                            visualDensity: VisualDensity.comfortable,
                            dense: true,
                            minTileHeight: 40,
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image:user==null?AssetImage("assets/profile.png"):NetworkImage(user!.profilePicture),
                                ),
                              ),
                            ),
                            title: Text(
                              "Good Morning !",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black38,
                              ),
                            ),
                            subtitle: Text(
                              user==null?"Loading ... ":user!.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: ()async {
                                var list=await _repo.getAllProducts();
                                var wishlist=await _repo.favouriteProducts(list);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductsView(name: "My WishList", products: wishlist,
                                        ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.favorite_outline),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimationConfiguration.staggeredList(
                      position: 1,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () async{
                              var list=await _repo.getAllProducts();
                              if(mounted){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => SearchField(list: list),));
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(color: Colors.black45,width: 2)
                              ),
                              child: Row(
                                children: [
                                  Padding(padding: EdgeInsetsGeometry.all(6)),
                                  Icon(Icons.search),
                                  Padding(padding: EdgeInsetsGeometry.all(8)),
                                  Text("Search",style: TextStyle(fontSize: 15),)
                                ],
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.all(10)),
                  SliverToBoxAdapter(
                    child: AnimationConfiguration.staggeredList(
                      position: 2,
                      duration: const Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                "Special Offers",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                child: Text(
                                  "",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.all(10)),
                  SliverToBoxAdapter(
                    child: AnimationConfiguration.staggeredList(
                      position: 3,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        child: FadeInAnimation(child: Imageslider()),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.all(10)),
                  SliverToBoxAdapter(
                    child: AnimationConfiguration.staggeredList(
                      position: 4,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 100,
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: ()async{
                                        List<Product>list =await _repo.getAllProducts();
                                        List<Product> clothes=_repo.clothesProducts(list);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsView(name: "Clothes", products:clothes),));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          194,
                                          192,
                                          191,
                                        ),
                                        radius: 25,
                                        child: Image.asset(
                                          height: 22,
                                          width: 22,
                                          "assets/casual-t-shirt-.png",
                                        ),
                                      ),
                                    ),
                                    Text("Clothes"),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:()async{
                                        List<Product>list =await _repo.getAllProducts();
                                        List<Product> clothes=_repo.shoesProducts(list);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsView(name: "Shoes", products:clothes),));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          194,
                                          192,
                                          191,
                                        ),
                                        radius: 25,
                                        child: Image.asset(
                                          height: 22,
                                          width: 22,
                                          "assets/sport-shoe.png",
                                        ),
                                      ),
                                    ),
                                    Text("Shoes"),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:()async{
                                        List<Product>list =await _repo.getAllProducts();
                                        List<Product> clothes=_repo.bagsProducts(list);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsView(name: "Bags", products:clothes),));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          194,
                                          192,
                                          191,
                                        ),
                                        radius: 25,
                                        child: Image.asset(
                                          height: 30,
                                          width: 22,
                                          "assets/handbag.png",
                                        ),
                                      ),
                                    ),
                                    Text("Bags"),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:()async{
                                        List<Product>list =await _repo.getAllProducts();
                                        List<Product> clothes=_repo.electronicsProducts(list);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsView(name: "Electronics", products:clothes),));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(255,194,192,191),
                                        radius: 25,
                                        child: Image.asset(
                                          height: 22,
                                          width: 22,
                                          "assets/device.png",
                                        ),
                                      ),
                                    ),
                                    Text("Electronics"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.all(10)),
                  SliverToBoxAdapter(
                    child: AnimationConfiguration.staggeredList(
                      position: 5,
                      duration: const Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        child: Text(
                          "Most Popular",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.all(10)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: AnimationConfiguration.staggeredList(
                        position: 6,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 200,
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<HomeProductsBloc>().add(FetchProducts());
                                    },
                                    child: Catgories(
                                      name: "All",
                                      selected: state.isAll,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<HomeProductsBloc>().add(FetchClothes());
                                    },
                                    child: Catgories(
                                      name: "Clothes",
                                      selected: state.isClothes,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<HomeProductsBloc>().add(FetchShoes());
                                    },
                                    child: Catgories(
                                      name: "Shoes",
                                      selected: state.isShoes,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<HomeProductsBloc>().add(FetchBags());
                                    },
                                    child: Catgories(
                                      name: "Bags",
                                      selected: state.isBag,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<HomeProductsBloc>().add(FetchElectronics());
                                    },
                                    child: Catgories(
                                      name: "Electronics",
                                      selected: state.isElectronics,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.all(10)),
                  switch (state) {
                    HomeProductsInitial() => InitialWidget() ,
                    HomeProductsLoading() => LoadingWidget(),
                    HomeProductsLoaded(products: var products) =>LoadedWidget(products: products),
                    HomeProductsError() => Error(),
                    HomeProductsState() => InitialWidget(),
                  }
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
class InitialWidget extends StatelessWidget {
  const InitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter();
  }
  }
  class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
class LoadedWidget extends StatelessWidget {
  final List<Product> products;
  const LoadedWidget({required this.products,super.key});

  @override
  Widget build(BuildContext context) {
    return Products(productList: products);
  }
}
class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}