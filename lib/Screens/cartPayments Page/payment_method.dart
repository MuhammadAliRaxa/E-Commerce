import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app/stripe_payment/payment_services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:google_fonts/google_fonts.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  PaymentServices payment=PaymentServices();
  int selectedIndex=0;
  List<Map<String,dynamic>> items =[
    {
      "title":"PayPal",
      'icon':Icons.paypal_sharp
    },
    {
      "title":"Google Pay",
      "icon":Icons.payment_sharp
    },
    {
      "title":"Apple Pay",
      "icon":Icons.apple_sharp
    },
    {
      "title":"Visa Card",
      "icon":Icons.credit_card_off_sharp
    }
  ];
  @override
  Widget build(BuildContext context) {
    var Size(:height,:width)=MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Methods",style: GoogleFonts.anta(),),
      ),
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
              child:ListTile(
                                title: Text(
              items[index]['title'].toString(),
              style: GoogleFonts.anta(),
                                ),
                                leading: Icon(items[index]['icon'],),
                                trailing: selectedIndex==index? const Icon(Icons.check_circle) : const Icon(Icons.circle),
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
          onPressed: ()async{
           try {
              await payment.initPaymentSheet(ammount: "100", merchantName: "Malik Ali", currency: "usd");
            await payment.presentPaymentSheet();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Sucessfull")));
           }on StripeException catch (e) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Cancelled")));
           }
          }, child: Text("Continue",style: GoogleFonts.anta(fontSize: 20,color: Colors.white),)),)
      ),
    );
  }
}