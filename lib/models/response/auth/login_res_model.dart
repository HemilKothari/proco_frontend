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

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return LoginResponseModel(
      id: data['_id'] ?? '',
      profile: data['profile'] ?? '',
      userToken: data['userToken'] ?? '',
    );
  }

  final String id;
  final String profile;
  final String userToken;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'profile': profile,
        'userToken': userToken,
      };
}
