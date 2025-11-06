import 'package:carousel_slider/carousel_slider.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';

class Imageslider extends StatelessWidget {
  const Imageslider({super.key});


  @override
  Widget build(BuildContext context) {
    return FanCarouselImageSlider.sliderType1(
              imagesLink: [
                "assets/image1.png",
                "assets/image2.png",
                "assets/image3.png",
                "assets/image4.png"
              ],
              autoPlayInterval:const Duration(seconds: 8),
              imageFitMode: BoxFit.fill,
              imageRadius: 10,
              userCanDrag: true,
              isClickable: false,
              sidesOpacity: 0.5,
              slideViewportFraction: 1,
              isAssets: true,
              showIndicator: false,
              autoPlay: true,
              sliderHeight: 200,
 );
  }
}