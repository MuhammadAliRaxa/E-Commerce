class Product {
  int id;
  String name;
  String image;
  String price;
  double rating;
  bool isFavourite;
  bool? isShoes;
  bool? isClothes;
  bool? isBags;
  bool? isElectronics;
  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.isFavourite,
    this.isShoes,
    this.isClothes,
    this.isBags,
    this.isElectronics,
  });
  

  Product copyWith({
    int? id,
    String? name,
    String? image,
    String? price,
    double? rating,
    bool? isFavourite,
    bool? isShoes,
    bool? isClothes,
    bool? isBags,
    bool? isElectronics,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      isFavourite: isFavourite ?? this.isFavourite,
      isShoes: isShoes ?? this.isShoes,
      isClothes: isClothes ?? this.isClothes,
      isBags: isBags ?? this.isBags,
      isElectronics: isElectronics ?? this.isElectronics,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      rating: json['rating'],
      isFavourite: json['isFavourite'],
      isShoes: json['isShoes'],
      isClothes: json['isClothes'],
      isBags: json['isBags'],
      isElectronics: json['isElectronics'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'rating': rating,
      'isFavourite': isFavourite,
      'isShoes': isShoes,
      'isClothes': isClothes,
      'isBags': isBags,
      'isElectronics': isElectronics,
    };
  }

  @override
  String toString() {
    return '''Product(id: $id, name: $name, image: $image, price: $price, rating: $rating, isFavourite: $isFavourite, isShoes: $isShoes, isClothes: $isClothes, isBags: $isBags, isElectronics: $isElectronics)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Product &&
      other.id == id &&
      other.name == name &&
      other.image == image &&
      other.price == price &&
      other.rating == rating &&
      other.isFavourite == isFavourite &&
      other.isShoes == isShoes &&
      other.isClothes == isClothes &&
      other.isBags == isBags &&
      other.isElectronics == isElectronics;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      rating.hashCode ^
      isFavourite.hashCode ^
      isShoes.hashCode ^
      isClothes.hashCode ^
      isBags.hashCode ^
      isElectronics.hashCode;
  }
}
