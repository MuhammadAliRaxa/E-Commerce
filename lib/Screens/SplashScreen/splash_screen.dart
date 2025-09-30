import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/home_page.dart';
import 'package:flutter_e_commerce_app/Screens/boardingScreenPage/onbourdingscreen.dart';
import 'package:flutter_e_commerce_app/Screens/createAccountPage/create_account.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:word_carousel/word_carousel.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    showNextPage();
  }
  void showNextPage()async{
  bool isLogin;
  await SharedpreferancesHelper.setAccountAlreadyLogin(false);
  await SharedpreferancesHelper.makeInstance();
  bool isBoarding = await SharedpreferancesHelper.isBoardingDone();
  var user=FirebaseAuth.instance.currentUser;
  if(user!=null){
   isLogin=true;
  }else{
    isLogin=false;
  }
  Widget a=isBoarding?isLogin?HomePage():CreateAccount():Onbourdingscreen();
  await Future.delayed(Duration(seconds: 2));
  if (!mounted) return;
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => a,));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/c.png")),
            SizedBox(height: 20,),
            WordCarousel(containerColor: Colors.transparent,fixedText: "", rotatingWords: ["ecom"],stayDuration: Duration(milliseconds: 1200),),
            SizedBox(height: 300,),
            SpinKitFadingCircle(itemBuilder: (context, index) => DecoratedBox(decoration: BoxDecoration(
              color: Colors.black
            )),)
          ],
        ) ,),
    );
  }
}