import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/Configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/Screens/cartPayments%20Page/payment_method.dart';
import 'package:flutter_e_commerce_app/bloc/shipping%20address/shipping_address_bloc.dart';
import 'package:flutter_e_commerce_app/data/models/shipping_address.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingOptions extends StatefulWidget {
  const ShippingOptions({super.key});

  @override
  State<ShippingOptions> createState() => _ShippingOptionsState();
}

class _ShippingOptionsState extends State<ShippingOptions> {
  int selectedIndex=0;
  List<ShippingAddress> items =[ShippingAddress(
      title:"Economy",
      subtitle:"Estimated arrival in 10 days",
      price:"100"
    ),
    ShippingAddress(
      title:"Regular",
      subtitle:"Estimated arrival in 7 days",
      price:"200"
    ),
    ShippingAddress(
      title:"Cargo",
      subtitle:"Estimated arrival in 5 days",
      price:"300"
    ),
    ShippingAddress(
      title:"Express",
      subtitle:"Estimated arrival in 2 days",
      price:"500"
    )
  ];
 @override
  Widget build(BuildContext context) {
    var Size(:height,:width)=MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text('Choose Shipping',)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child:Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_shipping, color: Colors.white, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      items[index].subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Rs.${items[index].price}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(isSelected?Icons.check_circle:Icons.circle,size:20),
            ],
          ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: height*0.11,
        width: width,
        color: Colors.white,
        child: Padding(padding: EdgeInsets.all(20),child: ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black,)),
          onPressed: (){
            context.read<ShippingAddressBloc>().add(ChangeShippingAddressEvent(items[selectedIndex],SharedpreferancesHelper.getAddress()??"Not Added Address"));
            Navigator.of(context).pop();
          }, child: Text("Continue",style: TextStyle(fontSize: 20,color: Colors.white),)),)
      ),
    );
  }
}