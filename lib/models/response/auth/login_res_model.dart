import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    required this.id,
    required this.profile,
    required this.userToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        id: json['_id'],
        profile: json['profile'],
        userToken: json['userToken'],
      );
  final String id;
  final String profile;
  final String userToken;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'profile': profile,
        'userToken': userToken,
      };
}
