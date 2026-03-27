import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/services/helpers/user_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditState extends ChangeNotifier {
  // ── Backend fields ───────────────────────────────────────────────────────────
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

  // ── Local-only fields (stored in SharedPreferences) ──────────────────────────
  String age = '';
  String linkedInUrl = '';
  String gitHubUrl = '';
  String twitterUrl = '';
  String portfolioUrl = '';

  // ── Per-field visibility flags ───────────────────────────────────────────────
  bool showEmail = true;
  bool showPhone = true;
  bool showGender = true;
  bool showAge = true;
  bool showCollege = true;
  bool showSkills = true;
  bool showLinkedIn = true;
  bool showGitHub = true;
  bool showTwitter = true;
  bool showPortfolio = true;

  // ── Async state ──────────────────────────────────────────────────────────────
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  ProfileEditState() {
    _init();
  }

  Future<void> _init() async {
    await _loadLocalExtras();
    await _loadVisibility();
    await loadProfile();
  }

  // ── Load backend profile + local extras ──────────────────────────────────────
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

  // ── Save to backend + persist local extras ───────────────────────────────────
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
      if (ok == true) await _saveLocalExtras();
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

  // ── Local extras persistence ─────────────────────────────────────────────────
  Future<void> _loadLocalExtras() async {
    final prefs = await SharedPreferences.getInstance();
    age = prefs.getString('profile_age') ?? '';
    linkedInUrl = prefs.getString('profile_linkedin') ?? '';
    gitHubUrl = prefs.getString('profile_github') ?? '';
    twitterUrl = prefs.getString('profile_twitter') ?? '';
    portfolioUrl = prefs.getString('profile_portfolio') ?? '';
  }

  Future<void> _saveLocalExtras() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_age', age);
    await prefs.setString('profile_linkedin', linkedInUrl);
    await prefs.setString('profile_github', gitHubUrl);
    await prefs.setString('profile_twitter', twitterUrl);
    await prefs.setString('profile_portfolio', portfolioUrl);
  }

  // ── Per-field visibility ──────────────────────────────────────────────────────
  Future<void> _loadVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    showEmail = prefs.getBool('vis_email') ?? true;
    showPhone = prefs.getBool('vis_phone') ?? true;
    showGender = prefs.getBool('vis_gender') ?? true;
    showAge = prefs.getBool('vis_age') ?? true;
    showCollege = prefs.getBool('vis_college') ?? true;
    showSkills = prefs.getBool('vis_skills') ?? true;
    showLinkedIn = prefs.getBool('vis_linkedin') ?? true;
    showGitHub = prefs.getBool('vis_github') ?? true;
    showTwitter = prefs.getBool('vis_twitter') ?? true;
    showPortfolio = prefs.getBool('vis_portfolio') ?? true;
  }

  Future<void> toggleVisibility(String key) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'email':
        showEmail = !showEmail;
        await prefs.setBool('vis_email', showEmail);
        break;
      case 'phone':
        showPhone = !showPhone;
        await prefs.setBool('vis_phone', showPhone);
        break;
      case 'gender':
        showGender = !showGender;
        await prefs.setBool('vis_gender', showGender);
        break;
      case 'age':
        showAge = !showAge;
        await prefs.setBool('vis_age', showAge);
        break;
      case 'college':
        showCollege = !showCollege;
        await prefs.setBool('vis_college', showCollege);
        break;
      case 'skills':
        showSkills = !showSkills;
        await prefs.setBool('vis_skills', showSkills);
        break;
      case 'linkedin':
        showLinkedIn = !showLinkedIn;
        await prefs.setBool('vis_linkedin', showLinkedIn);
        break;
      case 'github':
        showGitHub = !showGitHub;
        await prefs.setBool('vis_github', showGitHub);
        break;
      case 'twitter':
        showTwitter = !showTwitter;
        await prefs.setBool('vis_twitter', showTwitter);
        break;
      case 'portfolio':
        showPortfolio = !showPortfolio;
        await prefs.setBool('vis_portfolio', showPortfolio);
        break;
    }
    notifyListeners();
  }

  // ── Setters ──────────────────────────────────────────────────────────────────
  void setField(String key, String value) {
    switch (key) {
      case 'phone':
        phone = value;
        break;
      case 'gender':
        gender = value;
        break;
      case 'age':
        age = value;
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
      case 'linkedin':
        linkedInUrl = value;
        break;
      case 'github':
        gitHubUrl = value;
        break;
      case 'twitter':
        twitterUrl = value;
        break;
      case 'portfolio':
        portfolioUrl = value;
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
