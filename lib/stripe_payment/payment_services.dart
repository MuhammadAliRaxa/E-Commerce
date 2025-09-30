import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentServices{
  Dio dio = Dio();
  Future<void> initPaymentSheet(
    {
      required String ammount,
      required String merchantName,
      required String currency
    }
  )async{
    try {
    final paymentIntent=await _createPayment(amount: int.parse(ammount).round(), currency: currency);
    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret:paymentIntent['client_secret'],
          merchantDisplayName: merchantName,
          style: ThemeMode.light,
    ));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<void> presentPaymentSheet()async{
    await Stripe.instance.presentPaymentSheet();
  }

  Future<Map<String, dynamic>> _createPayment({
  required int amount,
  required String currency,
}) async {
  final response = await dio.post(
    'https://api.stripe.com/v1/payment_intents?amount=$amount&currency=usd',
    options: Options(
      headers: {
        'Authorization':
        'Bearer sk_test_51RpbHgLQbomAbWqgAXRqlOSe4p7EwEMuNW44YkY7unf0QeCmzKl5ZmTFJRun6WtSBRJFUG62vLU0rDY9HDObYm9a00SayG9IXn',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    ),
  );

  return response.data;
}

}