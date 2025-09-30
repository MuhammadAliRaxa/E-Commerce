import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/page_view_bloc/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/page_view_bloc/bloc_state.dart';
import 'package:flutter_e_commerce_app/bloc/page_view_bloc/page_view_bloc.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/cart_page.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/home.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/order_page.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/profile_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected=0;

  PageController controller=PageController();

  @override
  void initState() {
    super.initState();
    selected=0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageViewBloc,PageViewState>(
      bloc: context.watch<PageViewBloc>(),
      builder: (context, state) => Scaffold(
        bottomNavigationBar:  StylishBottomBar(backgroundColor: Colors.white60,
        elevation: 20,
        currentIndex: state.index,
        onTap: (value)
        {
          context.read<PageViewBloc>().add(ChangeIndexEvent(index: value));
        },
        notchStyle: NotchStyle.square,
        items: [BottomBarItem(icon: Icon(Icons.home_filled), title: Text("Home"),selectedColor: Colors.black),
        BottomBarItem(icon: Icon(Icons.shopping_cart_checkout_rounded), title: Text("Cart"),selectedColor: Colors.black),
        BottomBarItem(icon: Icon(Icons.shopping_basket_rounded), title: Text("Order"),selectedColor: Colors.black),
        BottomBarItem(icon: Icon(Icons.person_2_rounded), title: Text("Profile"),selectedColor: Colors.black)],
        option: AnimatedBarOptions(
          iconSize: 25,
          inkColor: const Color.fromARGB(187, 255, 255, 255),
          padding: EdgeInsets.all(10),
          barAnimation: BarAnimation.liquid
        ),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            context.read<PageViewBloc>().add(ChangeIndexEvent(index: value));
          },
          controller: state.controller,
          children: [
           Home(),
           CartPage(),
           MyOrdersScreen(),
           ProfileScreen()
          ],
        ),
      ),
    );
  }
}
