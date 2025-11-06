import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/cart_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/counter_quantity/quantity_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/home_products/home_products_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/order%20bloc/order_bloc_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/page_view_bloc/page_view_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/product_bloc/product_bloc.dart';
import 'package:flutter_e_commerce_app/Configs/firebase_options.dart';
import 'package:flutter_e_commerce_app/Screens/SplashScreen/splash_screen.dart';
import 'package:flutter_e_commerce_app/Configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/bloc/shipping%20address/shipping_address_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/user%20profile/user_profile_bloc.dart';
import 'package:flutter_e_commerce_app/widget/custom_parent_widget.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedpreferancesHelper.makeInstance();
  Stripe.publishableKey="pk_test_51RpbHgLQbomAbWqggKYz1gY94p055skd0AyTCpkUCieGzbPz7RPQNGiU1kU5V6nL0BGUH4c94hVwNyCboUoM0M2000dwSLnxCS";
  await Hive.initFlutter();
  await Hive.openBox('address');
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
        BlocProvider<QuantityBloc>(create: (context) => QuantityBloc(),),
        BlocProvider<ProductBloc>(create:(context) => ProductBloc(),),
        BlocProvider<PageViewBloc>(create:  (context) => PageViewBloc(),),
        BlocProvider<HomeProductsBloc>(create:  (context) => HomeProductsBloc(),),
        BlocProvider<ShippingAddressBloc>(create:  (context) => ShippingAddressBloc(),),
        BlocProvider<OrderBlocBloc>(create:  (context) => OrderBlocBloc(),),
        BlocProvider<UserProfileBloc>(create:  (context) => UserProfileBloc()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: CustomParentWidget(child: SplashScreen()),
      ),
    );
  }
}