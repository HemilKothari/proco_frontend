import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/controllers/image_provider.dart';
import 'package:jobhub_v1/views/ui/auth/profile_state.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class EditTab extends StatefulWidget {
  const EditTab({super.key});

  @override
  State<EditTab> createState() => _EditTabState();
}

class _EditTabState extends State<EditTab> {
  static const Color _card = Color(0xFF0D1B2A);
  static const Color _teal = kTeal;
  static const Color _tealLight = kTealLight;
  static const Color _white = Colors.white;

  static const List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _collegeCtrl;
  late TextEditingController _branchCtrl;
  final _skillCtrl = TextEditingController();

  String? _selectedGender;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final s = context.read<ProfileEditState>();
      _phoneCtrl = TextEditingController(text: s.phone);
      _cityCtrl = TextEditingController(text: s.city);
      _stateCtrl = TextEditingController(text: s.state);
      _countryCtrl = TextEditingController(text: s.country);
      _collegeCtrl = TextEditingController(text: s.college);
      _branchCtrl = TextEditingController(text: s.branch);
      _selectedGender =
          _genderOptions.contains(s.gender) ? s.gender : null;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    _collegeCtrl.dispose();
    _branchCtrl.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final s = context.read<ProfileEditState>();
    s.setField('phone', _phoneCtrl.text.trim());
    s.setField('city', _cityCtrl.text.trim());
    s.setField('state', _stateCtrl.text.trim());
    s.setField('country', _countryCtrl.text.trim());
    s.setField('college', _collegeCtrl.text.trim());
    s.setField('branch', _branchCtrl.text.trim());
    s.setField('gender', _selectedGender ?? '');

    final imageNotifier = context.read<ImageNotifier>();
    final ok = await s.saveProfile(imageNotifier.selectedImage);
    if (!mounted) return;
    if (ok) {
      Get.snackbar('Saved', 'Profile updated successfully',
          colorText: _white, backgroundColor: Colors.green);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Get.offAll(() => const MainScreen());
    } else {
      Get.snackbar('Error', s.error ?? 'Update failed',
          colorText: _white, backgroundColor: Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileEditState>();
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar picker ─────────────────────────────────────────────
            _buildAvatarPicker(),
            SizedBox(height: 24.h),

            // ── Personal Info ─────────────────────────────────────────────
            _sectionHeader(
              title: 'Personal Info',
              showKey: 'phone',
              isVisible: state.showPhone,
              state: state,
            ),
            SizedBox(height: 10.h),
            _field(
              controller: _phoneCtrl,
              label: 'Phone Number',
              hint: '10-digit number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (!RegExp(r'^\d{10,15}$').hasMatch(v)) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 10.h),
            _genderDropdown(),
            SizedBox(height: 20.h),

            // ── Location ──────────────────────────────────────────────────
            _sectionHeader(
              title: 'Location',
              showKey: 'location',
              isVisible: state.showLocation,
              state: state,
            ),
            SizedBox(height: 10.h),
            _field(
              controller: _cityCtrl,
              label: 'City',
              icon: Icons.location_city_outlined,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            _field(
              controller: _stateCtrl,
              label: 'State',
              icon: Icons.map_outlined,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            _field(
              controller: _countryCtrl,
              label: 'Country',
              icon: Icons.flag_outlined,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 20.h),

            // ── Education ─────────────────────────────────────────────────
            _sectionHeader(
              title: 'Education',
              showKey: 'education',
              isVisible: state.showEducation,
              state: state,
            ),
            SizedBox(height: 10.h),
            _field(
              controller: _collegeCtrl,
              label: 'College / University',
              hint: 'Enter your institution name',
              icon: Icons.apartment_outlined,
            ),
            SizedBox(height: 10.h),
            _field(
              controller: _branchCtrl,
              label: 'Branch / Field of Study',
              hint: 'e.g. Computer Science',
              icon: Icons.school_outlined,
            ),
            SizedBox(height: 20.h),

            // ── Skills ────────────────────────────────────────────────────
            _sectionHeader(
              title: 'Skills',
              showKey: 'skills',
              isVisible: state.showSkills,
              state: state,
            ),
            SizedBox(height: 10.h),
            _skillsInput(state),
            SizedBox(height: 10.h),
            _skillsChips(state),
            SizedBox(height: 28.h),

            // ── Save button ───────────────────────────────────────────────
            _saveButton(state),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // ── Avatar picker ──────────────────────────────────────────────────────────
  Widget _buildAvatarPicker() {
    return Consumer<ImageNotifier>(
      builder: (context, imageNotifier, _) {
        return Center(
          child: Stack(
            children: [
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _card,
                  border: Border.all(color: _teal, width: 2.5),
                  image: imageNotifier.selectedImage != null
                      ? DecorationImage(
                          image: FileImage(imageNotifier.selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageNotifier.selectedImage == null
                    ? Icon(Icons.person_rounded,
                        size: 44.w, color: _teal.withOpacity(0.5))
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: imageNotifier.isLoading
                      ? null
                      : () async => await imageNotifier.pickImage(),
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: _teal,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF040326), width: 2),
                    ),
                    child: imageNotifier.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _white),
                          )
                        : const Icon(Icons.camera_alt_rounded,
                            size: 14, color: _white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Section header with visibility switch ──────────────────────────────────
  Widget _sectionHeader({
    required String title,
    required String showKey,
    required bool isVisible,
    required ProfileEditState state,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: _teal,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                  height: 1, color: _teal.withOpacity(0.3)),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isVisible ? 'Visible' : 'Hidden',
              style: TextStyle(
                color:
                    isVisible ? _teal : Colors.white38,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 4.w),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: isVisible,
                onChanged: (_) => state.toggleVisibility(showKey),
                activeColor: _teal,
                activeTrackColor: _teal.withOpacity(0.3),
                inactiveThumbColor: Colors.white38,
                inactiveTrackColor: Colors.white12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Text field ─────────────────────────────────────────────────────────────
  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _white, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle:
            const TextStyle(color: Colors.white38, fontSize: 14),
        hintStyle:
            const TextStyle(color: Colors.white24, fontSize: 13),
        prefixIcon: Icon(icon, color: _teal, size: 20),
        filled: true,
        fillColor: _card,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: _teal.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: _teal.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Colors.redAccent, width: 1.5),
        ),
        errorStyle:
            const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  // ── Gender dropdown ────────────────────────────────────────────────────────
  Widget _genderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle:
            const TextStyle(color: Colors.white38, fontSize: 14),
        prefixIcon:
            const Icon(Icons.person_outline, color: _teal),
        filled: true,
        fillColor: _card,
        contentPadding:
            EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: _teal.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: _teal.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _teal, width: 1.5),
        ),
      ),
      hint: const Text('Select gender',
          style: TextStyle(color: Colors.white38, fontSize: 14)),
      dropdownColor: _card,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: _teal),
      style: const TextStyle(color: _white, fontSize: 15),
      borderRadius: BorderRadius.circular(12),
      items: _genderOptions
          .map((g) => DropdownMenuItem(
                value: g,
                child:
                    Text(g, style: const TextStyle(color: _white)),
              ))
          .toList(),
      onChanged: (val) => setState(() => _selectedGender = val),
    );
  }

  // ── Skills input ───────────────────────────────────────────────────────────
  Widget _skillsInput(ProfileEditState state) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillCtrl,
            style: const TextStyle(color: _white, fontSize: 15),
            onFieldSubmitted: (_) => _addSkill(state),
            decoration: InputDecoration(
              labelText: 'Add a skill',
              hintText: 'e.g. Flutter, Python',
              labelStyle:
                  const TextStyle(color: Colors.white38, fontSize: 14),
              hintStyle:
                  const TextStyle(color: Colors.white24, fontSize: 13),
              prefixIcon: const Icon(Icons.psychology_outlined,
                  color: _teal, size: 20),
              filled: true,
              fillColor: _card,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: _teal.withOpacity(0.25)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: _teal.withOpacity(0.25)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: _teal, width: 1.5),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () => _addSkill(state),
          child: Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: _teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add_rounded,
                color: _white, size: 22),
          ),
        ),
      ],
    );
  }

  void _addSkill(ProfileEditState state) {
    final skill = _skillCtrl.text.trim();
    if (skill.isEmpty) return;
    state.addSkill(skill);
    _skillCtrl.clear();
  }

  // ── Skills chips ───────────────────────────────────────────────────────────
  Widget _skillsChips(ProfileEditState state) {
    if (state.skills.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: _teal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _teal.withOpacity(0.2)),
        ),
        child: Text(
          'No skills added yet',
          style: TextStyle(
              color: Colors.white38,
              fontSize: 13.sp,
              fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: _teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _teal.withOpacity(0.2)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: state.skills.map((skill) {
          return Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: _teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _teal.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  skill,
                  style: const TextStyle(
                      color: _white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () => state.removeSkill(skill),
                  child: const Icon(Icons.close_rounded,
                      size: 13, color: Colors.white60),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Save button ────────────────────────────────────────────────────────────
  Widget _saveButton(ProfileEditState state) {
    return GestureDetector(
      onTap: state.isSaving ? null : _save,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: state.isSaving
                ? [_teal.withOpacity(0.4), _teal.withOpacity(0.4)]
                : [kTeal, kTealLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: state.isSaving
              ? []
              : [
                  BoxShadow(
                    color: _teal.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Center(
          child: state.isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: _white),
                )
              : const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: _white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
        ),
      ),
    );
  }
}
