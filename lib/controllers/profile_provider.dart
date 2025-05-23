import 'package:flutter/material.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/models/response/auth/swipe_res_model.dart';
import 'package:jobhub_v1/services/helpers/auth_helper.dart';

class ProfileNotifier extends ChangeNotifier {
  // Fix: make nullable for proper push to home after login

  Future<ProfileRes?>? profile;
  Future<List<SwipedRes>>? swipedUsers;

  getProfile() async {
    profile = AuthHelper.getProfile();
  }

  getSwipedUsers(agentId) async {
    swipedUsers = AuthHelper.getUserProfiles(agentId);
    notifyListeners();
  }
}
