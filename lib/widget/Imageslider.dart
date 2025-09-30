import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';

class Imageslider extends StatelessWidget {
  const Imageslider({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCarouselSlider(
      
      animationDuration: Duration(seconds: 10),
      height: 200,
      items:[
        CarouselItem(
          image:const AssetImage("assets/image1.png"),
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          )
        ),
        CarouselItem(
          image:const AssetImage("assets/image2.png"),
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          )
        ),
        CarouselItem(
          image:const AssetImage("assets/image3.png"),
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          )
        ),
        CarouselItem(
          image:const AssetImage("assets/image4.png"),
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          )
        ),
      ] );
  }
}