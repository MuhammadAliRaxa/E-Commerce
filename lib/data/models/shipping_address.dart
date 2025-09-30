class ShippingAddress {
  String title;
  String subtitle;
  String price;
  ShippingAddress({
    required this.title,
    required this.subtitle,
    required this.price,
  });

  ShippingAddress copyWith({
    String? title,
    String? subtitle,
    String? price,
  }) {
    return ShippingAddress(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
    );
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      title: json['title'],
      subtitle: json['subtitle'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'price': price,
    };
  }

  @override
  String toString() => '''ShippingAddress(title: $title, subtitle: $subtitle, price: $price)''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ShippingAddress &&
      other.title == title &&
      other.subtitle == subtitle &&
      other.price == price;
  }

  @override
  int get hashCode => title.hashCode ^ subtitle.hashCode ^ price.hashCode;
}
