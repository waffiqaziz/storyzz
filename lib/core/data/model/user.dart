import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final String? token;
  final String? language;

  const User({this.name, this.email, this.password, this.token, this.language});

  @override
  String toString() =>
      'User(name: $name, email: $email, password: $password, token: $token, language: $language)';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'token': token,
      'language': language,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
      language: map['language'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  List<Object?> get props => [name, email, password, token, language];
}
