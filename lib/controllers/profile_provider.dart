import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/models/response/jobs/swipe_res_model.dart';
import 'package:jobhub_v1/services/helpers/user_helper.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';

class ProfileNotifier extends ChangeNotifier {
  // Fix: make nullable for proper push to home after login

  Future<ProfileRes?>? profile;
  Future<List<SwipedRes>>? swipedUsers;

  getProfile() async {
    profile = UserHelper.getProfile();
    notifyListeners();
  }

  getSwipedUsers(agentId) async {
    swipedUsers = UserHelper.getUserProfiles(agentId);
    notifyListeners();
  }

  updateProfile(ProfileUpdateReq model, File? image) async {
    await UserHelper.updateProfile(model, image).then((response) {
      if (response) {
        Get.snackbar(
          'Profile Update',
          'Enjoy your search for a job',
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.add_alert),
        );

        Future.delayed(const Duration(seconds: 3)).then((value) {
          Get.offAll(() => const MainScreen());
        });
      } else {
        Get.snackbar(
          'Updating Failed',
          'Please try again',
          colorText: Color(kLight.value),
          backgroundColor: Color(kOrange.value),
          icon: const Icon(Icons.add_alert),
        );
      }
    });
  }
}
