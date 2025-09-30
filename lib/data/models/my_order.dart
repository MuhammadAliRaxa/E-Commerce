import 'package:flutter/foundation.dart';

import 'package:flutter_e_commerce_app/data/models/cart_product.dart';

class MyOrder {
  String? id;
  String isPending;
  String address;
  List<CartItem> items;
  MyOrder({
    this.id,
    required this.isPending,
    required this.address,
    required this.items,
  });

  MyOrder copyWith({
    String? id,
    String? isPending,
    String? address,
    List<CartItem>? items,
  }) {
    return MyOrder(
      id: id ?? this.id,
      isPending: isPending ?? this.isPending,
      address: address ?? this.address,
      items: items ?? this.items,
    );
  }

  factory MyOrder.fromJson(Map<String, dynamic> json,String id) {
    return MyOrder(
      id: id,
      isPending: json['isPending'],
      address: json['address'],
      items: List<CartItem>.from(json['items']?.map((x) => CartItem.fromJson(x,x.id))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isPending': isPending,
      'address': address,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '''MyOrder(id: $id, isPending: $isPending, address: $address, items: $items)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyOrder &&
      other.id == id &&
      other.isPending == isPending &&
      other.address == address &&
      listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      isPending.hashCode ^
      address.hashCode ^
      items.hashCode;
  }
  }
