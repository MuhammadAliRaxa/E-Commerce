import 'package:flutter/foundation.dart';

import 'package:flutter_e_commerce_app/data/models/cart_product.dart';

class MyOrder {
  final String saleId;
  String? customerId;
  final List<CartItem> items;
  final double discount;
  final double totalAmount;
  final String? paymentMethod;
  final String status;
  final DateTime createdAt;
    MyOrder({
    required this.saleId,
    this.customerId,
    required this.items,
    required this.discount,
    required this.totalAmount,
    this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  MyOrder copyWith({
    String? saleId,
    String? customerId,
    List<CartItem>? items,
    double? discount,
    double? totalAmount,
    String? paymentMethod,
    String? status,
    DateTime? createdAt,
  }) {
    return MyOrder(
      saleId: saleId ?? this.saleId,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MyOrder.fromJson(Map<String, dynamic> json) {
    return MyOrder(
      saleId: json['saleId'],
      customerId: json['customerId'],
      items: List<CartItem>.from(json['items']?.map((x) => CartItem.fromJson(x,x["customerId"]))),
      discount: json['discount'],
      totalAmount: json['totalAmount'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saleId': saleId,
      'customerId': customerId,
      'items': items.map((x) => x.toJson()).toList(),
      'discount': discount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '''MyOrder(saleId: $saleId, customerId: $customerId, items: $items, discount: $discount, totalAmount: $totalAmount, paymentMethod: $paymentMethod, status: $status, createdAt: $createdAt)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyOrder &&
      other.saleId == saleId &&
      other.customerId == customerId &&
      listEquals(other.items, items) &&
      other.discount == discount &&
      other.totalAmount == totalAmount &&
      other.paymentMethod == paymentMethod &&
      other.status == status &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return saleId.hashCode ^
      customerId.hashCode ^
      items.hashCode ^
      discount.hashCode ^
      totalAmount.hashCode ^
      paymentMethod.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
  }
}
