class CartItem {
  String? id;
  String name;
  String price;
  String? color;
  String? size;
  String image;
  int quantity;
  double rating;
  CartItem({
    this.id,
    required this.name,
    required this.price,
    this.color,
    this.size,
    required this.image,
    required this.quantity,
    required this.rating,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? price,
    String? color,
    String? size,
    String? image,
    int? quantity,
    double? rating,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      color: color ?? this.color,
      size: size ?? this.size,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json, String id) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      color: json['color'],
      size: json['size'],
      image: json['image'],
      quantity: json['quantity'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'color': color,
      'size': size,
      'image': image,
      'quantity': quantity,
      'rating': rating,
    };
  }

  @override
  String toString() {
    return '''CartItem(id: $id, name: $name, price: $price, color: $color, size: $size, image: $image, quantity: $quantity, rating: $rating)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CartItem &&
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.color == color &&
      other.size == size &&
      other.image == image &&
      other.quantity == quantity &&
      other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      color.hashCode ^
      size.hashCode ^
      image.hashCode ^
      quantity.hashCode ^
      rating.hashCode;
  }
}
