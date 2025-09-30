import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/Screens/createAccountPage/create_account.dart';
import 'package:flutter_e_commerce_app/Screens/login_User/login.dart';
import 'package:flutter_e_commerce_app/configs/sharedPreferances.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
class Onbourdingscreen extends StatelessWidget{
  const Onbourdingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(totalPage: 3,
    addController: true,
    controllerColor: Colors.black45,
    trailing: Text("Login",style: TextStyle(fontSize: 17,color: Colors.red),),
    trailingFunction: ()async{
      await SharedpreferancesHelper.setBoardingtoDone(true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),));
    },
     pageBodies: [
      Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'We provide high quality products just for you .',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Your satisfaction is our number one priority.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ), 
              const SizedBox(
                height: 20,
              ),
              
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                "Let's fulfill your daily needs with Ecom right's now !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ), 
              const SizedBox(
                height: 20,
              ),
              
            ],
          ),
        ),
    ],headerBackgroundColor: Colors.black, background: [
      Image.asset(
        fit: BoxFit.fill,
          'assets/boarding01.png',
          height: 500,
        ),
        Image.asset(
          fit: BoxFit.fill,
          'assets/boarding02.png',
          height: 500,
        ),
        Image.asset(
          fit: BoxFit.fill,
          'assets/boarding03.png',
          height: 500,
        ),
    ], speed: 1.8,
    finishButtonText: "Register",
    onFinish: ()async{
      await SharedpreferancesHelper.setBoardingtoDone(true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreateAccount(),));
    },
    hasSkip: true,
    skipTextButton: Text("Skip"),
    pageBackgroundColor: Colors.white60,

    finishButtonStyle: FinishButtonStyle(backgroundColor: Colors.black54,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }
}