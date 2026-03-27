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
    final location = [state.city, state.state, state.country]
        .where((s) => s.isNotEmpty)
        .join(', ');
    final education = [state.college, state.branch]
        .where((s) => s.isNotEmpty)
        .join(' · ');

    final hasAnything = (state.showEmail && state.email.isNotEmpty) ||
        (state.showPhone && state.phone.isNotEmpty) ||
        (state.showGender && state.gender.isNotEmpty) ||
        (state.showAge && state.age.isNotEmpty) ||
        (state.showCollege && education.isNotEmpty) ||
        location.isNotEmpty ||
        (state.showSkills && state.skills.isNotEmpty) ||
        (state.showLinkedIn && state.linkedInUrl.isNotEmpty) ||
        (state.showGitHub && state.gitHubUrl.isNotEmpty) ||
        (state.showTwitter && state.twitterUrl.isNotEmpty) ||
        (state.showPortfolio && state.portfolioUrl.isNotEmpty);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _buildHeader(state),
          SizedBox(height: 20.h),

          if (!hasAnything) ...[
            _emptyState(),
          ] else ...[
            // ── Personal Info ────────────────────────────────────────────
            if (state.showEmail && state.email.isNotEmpty) ...[
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
            if (state.showAge && state.age.isNotEmpty) ...[
              _infoCard(Icons.cake_outlined, 'Age', state.age),
              SizedBox(height: 10.h),
            ],

            // ── Location (always shown — no toggle) ──────────────────────
            if (location.isNotEmpty) ...[
              _infoCard(
                  Icons.location_on_outlined, 'Location', location),
              SizedBox(height: 10.h),
            ],

            // ── Education ────────────────────────────────────────────────
            if (state.showCollege && education.isNotEmpty) ...[
              _infoCard(Icons.school_outlined, 'Education', education),
              SizedBox(height: 10.h),
            ],

            // ── Skills ───────────────────────────────────────────────────
            if (state.showSkills && state.skills.isNotEmpty) ...[
              _skillsCard(state.skills),
              SizedBox(height: 10.h),
            ],

            // ── Social & Links ───────────────────────────────────────────
            if ((state.showLinkedIn && state.linkedInUrl.isNotEmpty) ||
                (state.showGitHub && state.gitHubUrl.isNotEmpty) ||
                (state.showTwitter && state.twitterUrl.isNotEmpty) ||
                (state.showPortfolio &&
                    state.portfolioUrl.isNotEmpty)) ...[
              SizedBox(height: 4.h),
              _socialSection(state),
            ],
          ],
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(ProfileEditState state) {
    return Row(
      children: [
        Container(
          width: 68.w,
          height: 68.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _teal, width: 2.5),
          ),
          child: ClipOval(
            child: state.profileImageUrl.isEmpty ||
                    state.profileImageUrl == 'null'
                ? Image.asset('assets/images/user.png',
                    fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: state.profileImageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover),
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.username,
                style: TextStyle(
                  color: _white,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (state.showEmail && state.email.isNotEmpty)
                Text(
                  state.email,
                  style: TextStyle(
                    color: _tealLight,
                    fontSize: 12.sp,
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

  // ── Info card ──────────────────────────────────────────────────────────────
  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _teal.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _teal, size: 18),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 14,
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

  // ── Skills card ────────────────────────────────────────────────────────────
  Widget _skillsCard(List<String> skills) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _teal.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined,
                  color: _teal, size: 18),
              SizedBox(width: 10.w),
              const Text(
                'Skills',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
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
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _teal.withOpacity(0.4)),
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

  // ── Social links section ───────────────────────────────────────────────────
  Widget _socialSection(ProfileEditState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _teal.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link_rounded, color: _teal, size: 18),
              SizedBox(width: 10.w),
              const Text(
                'Social & Links',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (state.showLinkedIn && state.linkedInUrl.isNotEmpty)
            _socialRow(Icons.link_rounded, 'LinkedIn',
                state.linkedInUrl),
          if (state.showGitHub && state.gitHubUrl.isNotEmpty)
            _socialRow(
                Icons.code_rounded, 'GitHub', state.gitHubUrl),
          if (state.showTwitter && state.twitterUrl.isNotEmpty)
            _socialRow(Icons.alternate_email_rounded, 'Twitter / X',
                state.twitterUrl),
          if (state.showPortfolio && state.portfolioUrl.isNotEmpty)
            _socialRow(Icons.language_rounded, 'Portfolio',
                state.portfolioUrl),
        ],
      ),
    );
  }

  Widget _socialRow(IconData icon, String label, String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, color: _teal, size: 15),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 10),
                ),
                Text(
                  url,
                  style: TextStyle(
                    color: _tealLight,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: _tealLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility_off_outlined,
                size: 46, color: _teal.withOpacity(0.35)),
            SizedBox(height: 12.h),
            Text(
              'All fields are hidden',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Toggle visibility in the Edit tab',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
