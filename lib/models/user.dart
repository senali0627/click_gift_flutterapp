class User {
  final String name;
  final String email;
  final String address;
  final String password;

  User({required this.name, required this.email,required this.address, required this.password});

  Map<String, dynamic> toJson() => {
    'name': name,
    'email':email,
    'address': address,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email:json['email'],
    address: json['address'],
    password: json['password'],
  );
}