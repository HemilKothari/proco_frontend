/*import 'dart:convert';

SignupModel signupModelFromJson(String str) =>
    SignupModel.fromJson(json.decode(str));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
  SignupModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        username: json['username'],
        email: json['email'],
        password: json['password'],
      );

  final String username;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}*/
import 'dart:convert';

SignupModel signupModelFromJson(String str) =>
    SignupModel.fromJson(json.decode(str));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
  SignupModel({
    required this.username,
    required this.email,
    required this.password,
    required this.college,
    required this.gender,
    required this.city,
    required this.state,
    required this.country,
    required this.branch,
  });

  final String username;
  final String email;
  final String password;
  final String college;
  final String gender;
  final String city;
  final String state;
  final String country;
  final String branch;

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        username: json['username'],
        email: json['email'],
        password: json['password'],
        college: json['college'],
        gender: json['gender'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        branch: json['branch'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'college': college,
        'gender': gender,
        'city': city,
        'state': state,
        'country': country,
        'branch': branch,
      };
}
