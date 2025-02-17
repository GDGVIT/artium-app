import 'package:flutter/material.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

class User {
  final String name;
  final String email;
  final String? profileImage;

  User({required this.name, required this.email, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      profileImage: json['image'],
    );
  }
}
