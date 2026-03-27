import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/services/helpers/user_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditState extends ChangeNotifier {
  // ── Field values ────────────────────────────────────────────────────────────
  String username = '';
  String email = '';
  String phone = '';
  String gender = '';
  String city = '';
  String state = '';
  String country = '';
  String college = '';
  String branch = '';
  List<String> skills = [];
  String profileImageUrl = '';

  // ── Visibility flags (persisted locally) ────────────────────────────────────
  bool showPhone = true;
  bool showGender = true;
  bool showEmail = true;
  bool showLocation = true;
  bool showEducation = true;
  bool showSkills = true;

  // ── Async state ─────────────────────────────────────────────────────────────
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  ProfileEditState() {
    _init();
  }

  Future<void> _init() async {
    await _loadVisibility();
    await loadProfile();
  }

  // ── Load profile from backend ────────────────────────────────────────────────
  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await UserHelper.getProfile();
      if (data != null) {
        username = data.username;
        email = data.email;
        phone = data.phone;
        gender = data.gender;
        city = data.city;
        state = data.state;
        country = data.country;
        college = data.college;
        branch = data.branch;
        skills = List<String>.from(data.skills);
        profileImageUrl = data.profile;
      } else {
        error = 'Could not load profile';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Save profile to backend ──────────────────────────────────────────────────
  Future<bool> saveProfile(File? image) async {
    isSaving = true;
    notifyListeners();
    try {
      final req = ProfileUpdateReq(
        city: city,
        state: state,
        country: country,
        phone: phone,
        skills: skills,
        college: college,
        branch: branch,
        gender: gender.isEmpty ? null : gender,
      );
      final ok = await UserHelper.updateProfile(req, image);
      isSaving = false;
      notifyListeners();
      return ok == true;
    } catch (e) {
      isSaving = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Visibility persistence ────────────────────────────────────────────────────
  Future<void> _loadVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    showPhone = prefs.getBool('vis_phone') ?? true;
    showGender = prefs.getBool('vis_gender') ?? true;
    showEmail = prefs.getBool('vis_email') ?? true;
    showLocation = prefs.getBool('vis_location') ?? true;
    showEducation = prefs.getBool('vis_education') ?? true;
    showSkills = prefs.getBool('vis_skills') ?? true;
  }

  Future<void> toggleVisibility(String key) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'phone':
        showPhone = !showPhone;
        await prefs.setBool('vis_phone', showPhone);
        break;
      case 'gender':
        showGender = !showGender;
        await prefs.setBool('vis_gender', showGender);
        break;
      case 'email':
        showEmail = !showEmail;
        await prefs.setBool('vis_email', showEmail);
        break;
      case 'location':
        showLocation = !showLocation;
        await prefs.setBool('vis_location', showLocation);
        break;
      case 'education':
        showEducation = !showEducation;
        await prefs.setBool('vis_education', showEducation);
        break;
      case 'skills':
        showSkills = !showSkills;
        await prefs.setBool('vis_skills', showSkills);
        break;
    }
    notifyListeners();
  }

  // ── Field setters called from EditTab ────────────────────────────────────────
  void setField(String key, String value) {
    switch (key) {
      case 'phone':
        phone = value;
        break;
      case 'gender':
        gender = value;
        break;
      case 'city':
        city = value;
        break;
      case 'state':
        state = value;
        break;
      case 'country':
        country = value;
        break;
      case 'college':
        college = value;
        break;
      case 'branch':
        branch = value;
        break;
    }
    notifyListeners();
  }

  void addSkill(String skill) {
    if (skill.isNotEmpty && !skills.contains(skill)) {
      skills = [...skills, skill];
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    skills = skills.where((s) => s != skill).toList();
    notifyListeners();
  }
}
