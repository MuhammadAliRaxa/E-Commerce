class OrderItem {
  final String id;
  final String name;
  final String color;
  final String? size;
  final int quantity;
  final double price;
  final String image;
  final String status;
  const OrderItem({
    required this.id,
    required this.name,
    required this.color,
    this.size,
    required this.quantity,
    required this.price,
    required this.image,
    required this.status,
  });

  OrderItem copyWith({
    String? id,
    String? name,
    String? color,
    String? size,
    int? quantity,
    double? price,
    String? image,
    String? status,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      size: json['size'],
      quantity: json['quantity'],
      price: json['price'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
      'image': image,
      'status': status,
    };
  }

  @override
  String toString() {
    return '''OrderItem(id: $id, name: $name, color: $color, size: $size, quantity: $quantity, price: $price, image: $image, status: $status)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderItem &&
      other.id == id &&
      other.name == name &&
      other.color == color &&
      other.size == size &&
      other.quantity == quantity &&
      other.price == price &&
      other.image == image &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      color.hashCode ^
      size.hashCode ^
      quantity.hashCode ^
      price.hashCode ^
      image.hashCode ^
      status.hashCode;
  }
}
