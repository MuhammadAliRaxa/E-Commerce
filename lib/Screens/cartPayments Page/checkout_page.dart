import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/cart_page.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/PageViews/home.dart';
import 'package:flutter_e_commerce_app/Screens/HomePage/home_page.dart';
import 'package:flutter_e_commerce_app/Screens/cartPayments%20Page/shippingPage.dart';
import 'package:flutter_e_commerce_app/Screens/profile%20pages/add_new_address.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/bloc_event.dart';
import 'package:flutter_e_commerce_app/bloc/cart_product/cart_bloc.dart';
import 'package:flutter_e_commerce_app/bloc/shipping%20address/shipping_address_bloc.dart';
import 'package:flutter_e_commerce_app/configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/data/models/my_order.dart';
import 'package:flutter_e_commerce_app/data/models/shipping_address.dart';
import 'package:flutter_e_commerce_app/data/repoositries/product_repositry.dart';
import 'package:flutter_e_commerce_app/stripe_payment/payment_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  CheckoutScreen({required this.cartItems,super.key});

  double get subtotal => cartItems.fold(0, (sum, item) => sum + double.parse(item.price)* item.quantity);
  PaymentServices payment=PaymentServices();
  double total=0;
  @override
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ShippingAddressBloc,ShippingAddressState>(
        bloc:context.watch<ShippingAddressBloc>(),
        builder: (context, state) => SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isTablet = constraints.maxWidth > 600;
              return Column(
                children: [
                  // Header
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32 : 16,
                        vertical: 16,
                      ),
                      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShippingAddress(() =>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AddNewAddressScreen(),)) ,state.homeAddress),
          SizedBox(height: 24),
          _buildOrderList(),
          SizedBox(height: 24),
          _buildShippingOptions(state.address,() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShippingOptions(),)),),
          SizedBox(height: 24),
          _buildPromoCode(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ShippingOptions(),)),),
          SizedBox(height: 24),
          _buildOrderSummary(double.parse(state.address.price),0),
          SizedBox(height: 100),  
        ],
            ),
                    ),
                  ),
                  
                  // Bottom Button
                  _buildBottomButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:16,
        vertical: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, size:24),
          ),
          SizedBox(width: 8),
          Text(
            'Checkout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, size:24),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress(VoidCallback pressed,String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: Colors.white, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize:16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: pressed,
                icon: Icon(Icons.edit, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cartItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _buildCartItem(cartItems[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(item.image),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    
                    item.color!=null?Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getColorFromName(item.color!),
                        shape: BoxShape.circle,
                      ),
                    ):SizedBox(),
                    SizedBox(width: 8),
                    Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (item.size != null) ...[
                      SizedBox(width: 16),
                      Text(
                        'Size = ${item.size}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${double.parse(item.price).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item.quantity}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOptions(ShippingAddress address,VoidCallback pressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Shipping',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
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
                      address.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      address.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                address.price,
                style: TextStyle(
                  fontSize:  16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed:pressed,
                icon: Icon(Icons.edit,size:20),
              ),
            ],
          ),
        ),
      ],
    );
  }  

  Widget _buildPromoCode(VoidCallback pressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo Code',
          style: TextStyle(
            fontSize:  18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Text(
                      'Discount 30% Off',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap:(){},
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummary(double shipping,double? promo) {
    num a=promo??0;
    total=subtotal + shipping - a ;
    return Column(
      children: [
        _buildSummaryRow('Amount', 'Rs.${subtotal.toStringAsFixed(2)}'),
        SizedBox(height: 12),
        _buildSummaryRow('Shipping', 'Rs.${shipping.toStringAsFixed(2)}'),
        SizedBox(height: 12),
        _buildSummaryRow('Promo', '- Rs.${(-a).toStringAsFixed(2)}'),
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
        _buildSummaryRow('Total', 'Rs.${total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async{
            
            if(SharedpreferancesHelper.getAddress()!=null){
            try {
              String address=SharedpreferancesHelper.getAddress()!;
            await payment.initPaymentSheet(ammount: '${total.round()}', merchantName: "Muhammad Ali Raza", currency: "usd");
            await payment.presentPaymentSheet();
            Fluttertoast.showToast(msg: "Payment Successful ! ",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16
                                );
            MyOrder order=MyOrder(isPending: "Ongoing", address: address, items: cartItems);
            ProductRepositry productRepositry=ProductRepositry();
            await productRepositry.addProductInOder(order);
            Navigator.of(context).pop();
            context.read<CartBloc>().add(FetchCartProduct());
           }catch (e) {
            print(e.toString());
             Fluttertoast.showToast(msg: "Payment Cancelled !",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16
                                );
           }
            }else{
              Fluttertoast.showToast(msg: "Address not Added !",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16
                                );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue to Payment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'gray':
        return Colors.grey;
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'silver':
        return Colors.grey[300]!;
      default:
        return Colors.grey;
    }
  }
}