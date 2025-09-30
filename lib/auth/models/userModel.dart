class UserModel {
  final String id;
  final String name;
  final String nickName;
  final String dateofBirth;
  final String email;
  final String password;
  final String phoneNumber;
  final String gender;
  final String profilePicture;
  const UserModel({
    required this.id,
    required this.name,
    required this.nickName,
    required this.dateofBirth,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.gender,
    required this.profilePicture,
  });
  

  UserModel copyWith({
    String? id,
    String? name,
    String? nickName,
    String? dateofBirth,
    String? email,
    String? password,
    String? phoneNumber,
    String? gender,
    String? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      dateofBirth: dateofBirth ?? this.dateofBirth,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      nickName: json['nickName'],
      dateofBirth: json['dateofBirth'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickName': nickName,
      'dateofBirth': dateofBirth,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'profilePicture': profilePicture,
    };
  }

  @override
  String toString() {
    return '''UserModel(id: $id, name: $name, nickName: $nickName, dateofBirth: $dateofBirth, email: $email, password: $password, phoneNumber: $phoneNumber, gender: $gender, profilePicture: $profilePicture)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.name == name &&
      other.nickName == nickName &&
      other.dateofBirth == dateofBirth &&
      other.email == email &&
      other.password == password &&
      other.phoneNumber == phoneNumber &&
      other.gender == gender &&
      other.profilePicture == profilePicture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      nickName.hashCode ^
      dateofBirth.hashCode ^
      email.hashCode ^
      password.hashCode ^
      phoneNumber.hashCode ^
      gender.hashCode ^
      profilePicture.hashCode;
  }
}
