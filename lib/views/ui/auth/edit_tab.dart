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
  static const Color _bg = Color(0xFF040326);
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
  late TextEditingController _ageCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _collegeCtrl;
  late TextEditingController _branchCtrl;
  late TextEditingController _linkedInCtrl;
  late TextEditingController _gitHubCtrl;
  late TextEditingController _twitterCtrl;
  late TextEditingController _portfolioCtrl;
  final _skillCtrl = TextEditingController();

  String? _selectedGender;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final s = context.read<ProfileEditState>();
      _phoneCtrl = TextEditingController(text: s.phone);
      _ageCtrl = TextEditingController(text: s.age);
      _cityCtrl = TextEditingController(text: s.city);
      _stateCtrl = TextEditingController(text: s.state);
      _countryCtrl = TextEditingController(text: s.country);
      _collegeCtrl = TextEditingController(text: s.college);
      _branchCtrl = TextEditingController(text: s.branch);
      _linkedInCtrl = TextEditingController(text: s.linkedInUrl);
      _gitHubCtrl = TextEditingController(text: s.gitHubUrl);
      _twitterCtrl = TextEditingController(text: s.twitterUrl);
      _portfolioCtrl = TextEditingController(text: s.portfolioUrl);
      _selectedGender =
          _genderOptions.contains(s.gender) ? s.gender : null;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    _collegeCtrl.dispose();
    _branchCtrl.dispose();
    _linkedInCtrl.dispose();
    _gitHubCtrl.dispose();
    _twitterCtrl.dispose();
    _portfolioCtrl.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final s = context.read<ProfileEditState>();
    s.setField('phone', _phoneCtrl.text.trim());
    s.setField('age', _ageCtrl.text.trim());
    s.setField('city', _cityCtrl.text.trim());
    s.setField('state', _stateCtrl.text.trim());
    s.setField('country', _countryCtrl.text.trim());
    s.setField('college', _collegeCtrl.text.trim());
    s.setField('branch', _branchCtrl.text.trim());
    s.setField('linkedin', _linkedInCtrl.text.trim());
    s.setField('github', _gitHubCtrl.text.trim());
    s.setField('twitter', _twitterCtrl.text.trim());
    s.setField('portfolio', _portfolioCtrl.text.trim());
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
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ────────────────────────────────────────────────────
            _buildAvatarPicker(),
            SizedBox(height: 20.h),

            // ── Personal Info ─────────────────────────────────────────────
            _sectionDivider('Personal Info'),
            SizedBox(height: 12.h),
            _emailReadOnlyWithToggle(state),
            SizedBox(height: 10.h),
            _fieldWithToggle(
              controller: _phoneCtrl,
              label: 'Phone',
              icon: Icons.phone_outlined,
              visKey: 'phone',
              isVisible: state.showPhone,
              state: state,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v != null && v.isNotEmpty &&
                    !RegExp(r'^\d{10,15}$').hasMatch(v)) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 10.h),
            _genderRowWithToggle(state),
            SizedBox(height: 10.h),
            _fieldWithToggle(
              controller: _ageCtrl,
              label: 'Age',
              icon: Icons.cake_outlined,
              visKey: 'age',
              isVisible: state.showAge,
              state: state,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),

            // ── Location ──────────────────────────────────────────────────
            _sectionDivider('Location'),
            SizedBox(height: 12.h),
            _plainField(
              controller: _cityCtrl,
              label: 'City',
              icon: Icons.location_city_outlined,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            _plainField(
              controller: _stateCtrl,
              label: 'State',
              icon: Icons.map_outlined,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            _plainField(
              controller: _countryCtrl,
              label: 'Country',
              icon: Icons.flag_outlined,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 20.h),

            // ── Education ─────────────────────────────────────────────────
            _sectionDivider('Education'),
            SizedBox(height: 12.h),
            _fieldWithToggle(
              controller: _collegeCtrl,
              label: 'College / University',
              icon: Icons.apartment_outlined,
              visKey: 'college',
              isVisible: state.showCollege,
              state: state,
            ),
            SizedBox(height: 10.h),
            _plainField(
              controller: _branchCtrl,
              label: 'Branch / Field of Study',
              hint: 'e.g. Computer Science',
              icon: Icons.school_outlined,
            ),
            SizedBox(height: 20.h),

            // ── Skills ────────────────────────────────────────────────────
            _sectionDivider('Skills'),
            SizedBox(height: 8.h),
            _skillsToggleRow(state),
            SizedBox(height: 10.h),
            _skillsInput(state),
            SizedBox(height: 10.h),
            _skillsChips(state),
            SizedBox(height: 20.h),

            // ── Social / URLs ─────────────────────────────────────────────
            _sectionDivider('Social & Links'),
            SizedBox(height: 12.h),
            _fieldWithToggle(
              controller: _linkedInCtrl,
              label: 'LinkedIn URL',
              icon: Icons.link_rounded,
              visKey: 'linkedin',
              isVisible: state.showLinkedIn,
              state: state,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 10.h),
            _fieldWithToggle(
              controller: _gitHubCtrl,
              label: 'GitHub URL',
              icon: Icons.code_rounded,
              visKey: 'github',
              isVisible: state.showGitHub,
              state: state,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 10.h),
            _fieldWithToggle(
              controller: _twitterCtrl,
              label: 'Twitter / X URL',
              icon: Icons.alternate_email_rounded,
              visKey: 'twitter',
              isVisible: state.showTwitter,
              state: state,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 10.h),
            _fieldWithToggle(
              controller: _portfolioCtrl,
              label: 'Portfolio URL',
              icon: Icons.language_rounded,
              visKey: 'portfolio',
              isVisible: state.showPortfolio,
              state: state,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 28.h),

            // ── Save ──────────────────────────────────────────────────────
            _saveButton(state),
            SizedBox(height: 16.h),
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
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 86.w,
                height: 86.w,
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
                        size: 42.w, color: _teal.withOpacity(0.5))
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
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: _teal,
                      shape: BoxShape.circle,
                      border: Border.all(color: _bg, width: 2),
                    ),
                    child: imageNotifier.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(5),
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _white),
                          )
                        : const Icon(Icons.camera_alt_rounded,
                            size: 13, color: _white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Section divider label ──────────────────────────────────────────────────
  Widget _sectionDivider(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16.h,
          decoration: BoxDecoration(
            color: _teal,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            color: _white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  // ── Email read-only row with visibility toggle ────────────────────────────
  Widget _emailReadOnlyWithToggle(ProfileEditState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.email_outlined, color: _teal, size: 15),
            SizedBox(width: 6.w),
            Text(
              'Email',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Text(
              state.showEmail ? 'Visible' : 'Hidden',
              style: TextStyle(
                color: state.showEmail ? _tealLight : Colors.white38,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              height: 24,
              child: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: state.showEmail,
                  onChanged: (_) => state.toggleVisibility('email'),
                  activeColor: _teal,
                  activeTrackColor: _teal.withOpacity(0.3),
                  inactiveThumbColor: Colors.white38,
                  inactiveTrackColor: Colors.white12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: _card.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _teal.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline_rounded,
                  color: _teal.withOpacity(0.5), size: 14),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  state.email.isNotEmpty ? state.email : '—',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Field with inline visibility toggle ───────────────────────────────────
  Widget _fieldWithToggle({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String visKey,
    required bool isVisible,
    required ProfileEditState state,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row + toggle
        Row(
          children: [
            Icon(icon, color: _teal, size: 15),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Text(
              isVisible ? 'Visible' : 'Hidden',
              style: TextStyle(
                color: isVisible ? _tealLight : Colors.white38,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              height: 24,
              child: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: isVisible,
                  onChanged: (_) => state.toggleVisibility(visKey),
                  activeColor: _teal,
                  activeTrackColor: _teal.withOpacity(0.3),
                  inactiveThumbColor: Colors.white38,
                  inactiveTrackColor: Colors.white12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        // Text field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: _white, fontSize: 14.sp),
          validator: validator,
          decoration: _fieldDecoration(hint ?? label),
        ),
      ],
    );
  }

  // ── Plain field (no toggle) ────────────────────────────────────────────────
  Widget _plainField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: _white, fontSize: 14.sp),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        prefixIcon: Icon(icon, color: _teal, size: 18),
        filled: true,
        fillColor: _card,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _teal.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _teal.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
      filled: true,
      fillColor: _card,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _teal.withOpacity(0.25)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _teal.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _teal, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  // ── Gender row with toggle ─────────────────────────────────────────────────
  Widget _genderRowWithToggle(ProfileEditState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wc_outlined, color: _teal, size: 15),
            SizedBox(width: 6.w),
            Text(
              'Gender',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Text(
              state.showGender ? 'Visible' : 'Hidden',
              style: TextStyle(
                color: state.showGender ? _tealLight : Colors.white38,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              height: 24,
              child: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: state.showGender,
                  onChanged: (_) => state.toggleVisibility('gender'),
                  activeColor: _teal,
                  activeTrackColor: _teal.withOpacity(0.3),
                  inactiveThumbColor: Colors.white38,
                  inactiveTrackColor: Colors.white12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: InputDecoration(
            hintText: 'Select gender',
            hintStyle:
                const TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon: const Icon(Icons.person_outline,
                color: _teal, size: 18),
            filled: true,
            fillColor: _card,
            contentPadding:
                EdgeInsets.symmetric(vertical: 13.h, horizontal: 14.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _teal.withOpacity(0.25)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _teal.withOpacity(0.25)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _teal, width: 1.5),
            ),
          ),
          dropdownColor: const Color(0xFF0D2233),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _teal),
          style: TextStyle(color: _white, fontSize: 14.sp),
          borderRadius: BorderRadius.circular(12),
          items: _genderOptions
              .map((g) => DropdownMenuItem(
                    value: g,
                    child: Text(g,
                        style: const TextStyle(color: _white)),
                  ))
              .toList(),
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
      ],
    );
  }

  // ── Skills toggle row ──────────────────────────────────────────────────────
  Widget _skillsToggleRow(ProfileEditState state) {
    return Row(
      children: [
        const Icon(Icons.psychology_outlined, color: _teal, size: 15),
        SizedBox(width: 6.w),
        Text(
          'Skills',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 12.sp,
            fontFamily: 'Poppins',
          ),
        ),
        const Spacer(),
        Text(
          state.showSkills ? 'Visible' : 'Hidden',
          style: TextStyle(
            color: state.showSkills ? _tealLight : Colors.white38,
            fontSize: 11.sp,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(width: 2.w),
        SizedBox(
          height: 24,
          child: Transform.scale(
            scale: 0.75,
            child: Switch(
              value: state.showSkills,
              onChanged: (_) => state.toggleVisibility('skills'),
              activeColor: _teal,
              activeTrackColor: _teal.withOpacity(0.3),
              inactiveThumbColor: Colors.white38,
              inactiveTrackColor: Colors.white12,
            ),
          ),
        ),
      ],
    );
  }

  // ── Skills input ───────────────────────────────────────────────────────────
  Widget _skillsInput(ProfileEditState state) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillCtrl,
            style: TextStyle(color: _white, fontSize: 14.sp),
            onFieldSubmitted: (_) => _addSkill(state),
            decoration: InputDecoration(
              hintText: 'Add a skill (e.g. Flutter)',
              hintStyle:
                  const TextStyle(color: Colors.white24, fontSize: 13),
              prefixIcon: const Icon(Icons.add_circle_outline_rounded,
                  color: _teal, size: 18),
              filled: true,
              fillColor: _card,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _teal.withOpacity(0.25)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _teal.withOpacity(0.25)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _teal, width: 1.5),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () => _addSkill(state),
          child: Container(
            height: 46.h,
            width: 46.h,
            decoration: BoxDecoration(
              color: _teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add_rounded, color: _white, size: 20),
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
          color: _teal.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _teal.withOpacity(0.2)),
        ),
        child: Text(
          'No skills added yet',
          style: TextStyle(
              color: Colors.white38,
              fontSize: 12.sp,
              fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: _teal.withOpacity(0.07),
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
              color: _teal.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _teal.withOpacity(0.45)),
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
        height: 50.h,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
        ),
      ),
    );
  }
}
