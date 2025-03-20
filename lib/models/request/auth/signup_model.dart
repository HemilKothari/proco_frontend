import 'dart:convert';

SignupModel signupModelFromJson(String str) =>
    SignupModel.fromJson(json.decode(str));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
  SignupModel({
    this.username = '',
    this.email = '',
    this.password = '',
    this.college = '',
    this.branch = '',
    this.gender = '',
    this.city = '',
    this.state = '',
    this.country = '',
  });

  String username;
  String email;
  String password;
  String college;
  String branch;
  String gender;
  String city;
  String state;
  String country;

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        username: json['username'],
        email: json['email'],
        password: json['password'],
        college: json['college'],
        branch: json['branch'],
        gender: json['gender'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'college': college,
        'branch': branch,
        'gender': gender,
        'city': city,
        'state': state,
        'country': country,
      };
}
