import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/views/ui/auth/profile_state.dart';
import 'package:provider/provider.dart';

class ViewTab extends StatelessWidget {
  const ViewTab({super.key});

  static const Color _card = Color(0xFF0D1B2A);
  static const Color _teal = kTeal;
  static const Color _tealLight = kTealLight;
  static const Color _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileEditState>();
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(state),
          SizedBox(height: 20.h),
          if (state.showEmail) ...[
            _infoCard(Icons.email_outlined, 'Email', state.email),
            SizedBox(height: 10.h),
          ],
          if (state.showPhone && state.phone.isNotEmpty) ...[
            _infoCard(Icons.phone_outlined, 'Phone', state.phone),
            SizedBox(height: 10.h),
          ],
          if (state.showGender && state.gender.isNotEmpty) ...[
            _infoCard(Icons.wc_outlined, 'Gender', state.gender),
            SizedBox(height: 10.h),
          ],
          if (state.showLocation &&
              (state.city.isNotEmpty ||
                  state.state.isNotEmpty ||
                  state.country.isNotEmpty)) ...[
            _infoCard(
              Icons.location_on_outlined,
              'Location',
              [state.city, state.state, state.country]
                  .where((s) => s.isNotEmpty)
                  .join(', '),
            ),
            SizedBox(height: 10.h),
          ],
          if (state.showEducation &&
              (state.college.isNotEmpty || state.branch.isNotEmpty)) ...[
            _infoCard(
              Icons.school_outlined,
              'Education',
              [state.college, state.branch]
                  .where((s) => s.isNotEmpty)
                  .join(' · '),
            ),
            SizedBox(height: 10.h),
          ],
          if (state.showSkills && state.skills.isNotEmpty) ...[
            _skillsCard(state.skills),
            SizedBox(height: 10.h),
          ],
          if (!state.showEmail &&
              !state.showPhone &&
              !state.showGender &&
              !state.showLocation &&
              !state.showEducation &&
              !state.showSkills)
            _emptyState(),
        ],
      ),
    );
  }

  Widget _buildHeader(ProfileEditState state) {
    return Row(
      children: [
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _teal, width: 2.5),
          ),
          child: ClipOval(
            child: state.profileImageUrl.isEmpty ||
                    state.profileImageUrl == 'null'
                ? Image.asset('assets/images/user.png', fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: state.profileImageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Image.asset('assets/images/user.png', fit: BoxFit.cover),
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.username,
                style: TextStyle(
                  color: _white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (state.showEmail)
                Text(
                  state.email,
                  style: TextStyle(
                    color: _tealLight,
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _teal, size: 20),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillsCard(List<String> skills) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: _teal, size: 20),
              SizedBox(width: 10.w),
              const Text(
                'Skills',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _teal.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _teal.withOpacity(0.45)),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: _tealLight,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Icon(Icons.visibility_off_outlined,
                size: 48, color: _teal.withOpacity(0.35)),
            SizedBox(height: 12.h),
            Text(
              'All fields are hidden',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Toggle visibility in the Edit tab',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
