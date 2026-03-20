import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/services/helpers/user_helper.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  // ─── Theme colours (matching profile page) ───────────────────────────────
  static const Color _bg = Color(0xFF040326);
  static const Color _card = Color(0xFF08979F);
  static const Color _cardDark = Color(0xFF067078);
  static const Color _accent = Color(0xFF0BBFCA);
  static const Color _white = Colors.white;

  // ─── Form ─────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _collegeController = TextEditingController();
  final _branchController = TextEditingController();
  final _skillController = TextEditingController();

  // ✅ NEW fields present on backend / profile page
  String? _selectedGender;
  static const List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  List<String> skills = [];

  bool isLoading = true;
  bool isUpdating = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _collegeController.dispose();
    _branchController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  // ─── Data ─────────────────────────────────────────────────────────────────
  void _loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final profileData = await UserHelper.getProfile();
      if (profileData != null) {
        setState(() {
          _phoneController.text = profileData.phone ?? '';
          _cityController.text = profileData.city ?? '';
          _stateController.text = profileData.state ?? '';
          _countryController.text = profileData.country ?? '';
          _collegeController.text = profileData.college ?? '';
          _branchController.text = profileData.branch ?? '';
          skills = List<String>.from(profileData.skills ?? []);

          // ✅ Pre-select gender if stored
          final g = profileData.gender ?? '';
          _selectedGender = _genderOptions.contains(g) ? g : null;
        });
      } else {
        setState(() {
          errorMessage = 'Could not load profile data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading profile: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      _snack(
          'Validation Error', 'Please fill in all required fields', Colors.red);
      return;
    }

    setState(() {
      isUpdating = true;
      errorMessage = null;
    });

    try {
      final phone = _phoneController.text.trim();
      if (!_isValidPhone(phone))
        throw Exception('Please enter a valid phone number');

      final updateReq = ProfileUpdateReq(
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        phone: phone,
        profile: null,
        skills: skills,
        college: _collegeController.text.trim(),
        branch: _branchController.text.trim(),
        gender: _selectedGender, // ✅ pass gender
      );

      final response = await UserHelper.updateProfile(updateReq);

      if (response == true) {
        _snack('Success', 'Profile updated successfully', Colors.green);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Get.offAll(() => const MainScreen());
      } else {
        setState(() {
          errorMessage = 'Profile update failed. Please try again.';
        });
        _snack('Update Failed', 'Please check your information and try again',
            Colors.orange);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
      _snack('Error', e.toString(), Colors.red);
    } finally {
      if (mounted)
        setState(() {
          isUpdating = false;
        });
    }
  }

  bool _isValidPhone(String phone) =>
      phone.length >= 10 && RegExp(r'^\d{10,15}$').hasMatch(phone);

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) return;
    if (skills.contains(skill)) {
      _snack('Duplicate', 'This skill is already in your list', Colors.orange);
      return;
    }
    setState(() {
      skills.add(skill);
      _skillController.clear();
    });
  }

  void _snack(String title, String msg, Color color) {
    Get.snackbar(title, msg,
        colorText: _white,
        backgroundColor: color,
        duration: const Duration(seconds: 3));
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _white, size: 20),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              color: _white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: _white),
            onPressed: isLoading ? null : _loadProfile,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: _accent))
          : (errorMessage != null && errorMessage!.contains('Could not load'))
              ? _buildErrorView()
              : _buildForm(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _white, fontSize: 16)),
          const SizedBox(height: 24),
          _primaryButton('Try Again', _loadProfile),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Personal Info ──────────────────────────────────────────────
            _sectionLabel('Personal Info'),
            SizedBox(height: 12.h),
            _field(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '10-digit number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              required: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (!_isValidPhone(v)) return 'Enter a valid phone number';
                return null;
              },
            ),
            SizedBox(height: 12.h),

            // ✅ Gender dropdown
            _label('Gender'),
            SizedBox(height: 6.h),
            _genderDropdown(),
            SizedBox(height: 20.h),

            // ── Location ──────────────────────────────────────────────────
            _sectionLabel('Location'),
            SizedBox(height: 12.h),
            _field(
              controller: _cityController,
              label: 'City',
              icon: Icons.location_city_outlined,
              required: true,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            SizedBox(height: 12.h),
            _field(
              controller: _stateController,
              label: 'State',
              icon: Icons.map_outlined,
              required: true,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            SizedBox(height: 12.h),
            _field(
              controller: _countryController,
              label: 'Country',
              icon: Icons.flag_outlined,
              required: true,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            SizedBox(height: 20.h),

            // ── Education ─────────────────────────────────────────────────
            _sectionLabel('Education'),
            SizedBox(height: 12.h),
            _field(
              controller: _collegeController,
              label: 'College / University',
              hint: 'Enter your institution name',
              icon: Icons.apartment_outlined,
            ),
            SizedBox(height: 12.h),
            _field(
              controller: _branchController,
              label: 'Branch / Field of Study',
              hint: 'e.g. Computer Science',
              icon: Icons.school_outlined,
            ),
            SizedBox(height: 20.h),

            // ── Skills ────────────────────────────────────────────────────
            _sectionLabel('Skills'),
            SizedBox(height: 12.h),
            _skillsInput(),
            SizedBox(height: 12.h),
            _skillsChips(),
            SizedBox(height: 28.h),

            // ── Submit ────────────────────────────────────────────────────
            _primaryButton(
              isUpdating ? 'Updating...' : 'Save Changes',
              isUpdating ? null : _updateProfile,
              loading: isUpdating,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // ─── Reusable widgets ─────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: const TextStyle(
                color: _accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2)),
        SizedBox(height: 4.h),
        Container(height: 1, color: _card.withOpacity(0.5)),
      ],
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500));

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _white, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white60, fontSize: 14),
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
        prefixIcon: Icon(icon, color: _accent, size: 20),
        filled: true,
        fillColor: _card.withOpacity(0.25),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _card.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _card.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  // ✅ Gender dropdown styled to match the dark theme
  Widget _genderDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: _card.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _card.withOpacity(0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: const Text('Select gender',
              style: TextStyle(color: Colors.white30, fontSize: 14)),
          dropdownColor: const Color(0xFF0A2A2C),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _accent),
          isExpanded: true,
          style: const TextStyle(color: _white, fontSize: 15),
          items: _genderOptions
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
      ),
    );
  }

  Widget _skillsInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillController,
            style: const TextStyle(color: _white, fontSize: 15),
            onFieldSubmitted: (_) => _addSkill(),
            decoration: InputDecoration(
              labelText: 'Add a skill',
              hintText: 'e.g. Flutter, Python',
              labelStyle: const TextStyle(color: Colors.white60, fontSize: 14),
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
              prefixIcon: const Icon(Icons.psychology_outlined,
                  color: _accent, size: 20),
              filled: true,
              fillColor: _card.withOpacity(0.25),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _card.withOpacity(0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _card.withOpacity(0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _accent, width: 1.5),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: _addSkill,
          child: Container(
            height: 54.h,
            width: 54.h,
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.add_rounded, color: _white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _skillsChips() {
    if (skills.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: _card.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _card.withOpacity(0.3)),
        ),
        child: const Text('No skills added yet',
            style: TextStyle(color: Colors.white38, fontSize: 14),
            textAlign: TextAlign.center),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: _card.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _card.withOpacity(0.3)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills.map((skill) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(skill,
                    style: const TextStyle(
                        color: _white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () => setState(() => skills.remove(skill)),
                  child: const Icon(Icons.close_rounded,
                      size: 14, color: Colors.white70),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback? onTap,
      {bool loading = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          color: onTap == null ? _card.withOpacity(0.4) : _card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                      color: _card.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                      CircularProgressIndicator(strokeWidth: 2, color: _white))
              : Text(label,
                  style: const TextStyle(
                      color: _white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
