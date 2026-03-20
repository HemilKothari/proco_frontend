import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/request/chat/create_chat.dart';
import 'package:jobhub_v1/models/response/jobs/swipe_res_model.dart';
import 'package:jobhub_v1/services/helpers/chat_helper.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchedUsers extends StatefulWidget {
  const MatchedUsers({super.key});

  @override
  State<MatchedUsers> createState() => _MatchedUsersState();
}

class _MatchedUsersState extends State<MatchedUsers>
    with SingleTickerProviderStateMixin {
  final CardSwiperController controller = CardSwiperController();
  late AnimationController _fabAnimController;

  // ─── Light theme ─────────────────────────────────────────────────────────
  static const Color _bg = Colors.white;
  static const Color _navy = Color(0xFF040326);
  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _reject = Color(0xFFE8505B);
  static const Color _accept = Color(0xFF2DB67D);
  static const Color _grey = Color(0xFFF5F5F7);

  Future<String> _getJobId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentJobId') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeJobId();
  }

  void _initializeJobId() async {
    final jobId = await _getJobId();
    if (!mounted) return;
    Provider.of<JobsNotifier>(context, listen: false).getSwipedUsersId(jobId);
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
    List<SwipedRes> userList,
    String currentJobId,
  ) async {
    if (direction == CardSwiperDirection.right) {
      final user = userList[previousIndex];
      Provider.of<JobsNotifier>(context, listen: false)
          .addMatchedUsers(currentJobId, user.id);

      Get.snackbar(
        "It's a Match!",
        "You matched with ${user.username}",
        backgroundColor: _accept,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.favorite, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      final result = await ChatHelper.createChat(CreateChat(userId: user.id));

      if (result['success']) {
        Get.toNamed('/chat', arguments: {
          'chatId': result['chatId'],
          'user': user,
        });
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to create chat',
          backgroundColor: _reject,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Consumer<JobsNotifier>(
          builder: (context, jobsNotifier, _) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: FutureBuilder<String>(
                    future: _getJobId(),
                    builder: (context, jobSnap) {
                      if (!jobSnap.hasData) return _buildLoader();
                      return FutureBuilder<List<SwipedRes>>(
                        future: jobsNotifier.swipedUsers,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return _buildLoader();
                          }
                          if (snap.hasError) {
                            return _buildEmpty(
                                'Something went wrong.\nPlease try again.');
                          }
                          if (!snap.hasData || snap.data!.isEmpty) {
                            return _buildEmpty(
                                'No interested users yet.\nCheck back soon.');
                          }
                          return _buildSwipeArea(snap.data!, jobSnap.data!);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(6.w, 10.h, 20.w, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _navy, size: 20),
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interested Users',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'Swipe right to match · left to skip',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
        child: CircularProgressIndicator(color: _teal, strokeWidth: 2.5));
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline_rounded,
              size: 60, color: _teal.withOpacity(0.25)),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey,
              fontFamily: 'Poppins',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Swipe area ───────────────────────────────────────────────────────────
  Widget _buildSwipeArea(List<SwipedRes> userList, String jobId) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CardSwiper(
              controller: controller,
              scale: 0.93,
              padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
              cardsCount: userList.length,
              numberOfCardsDisplayed: userList.length.clamp(1, 3),
              allowedSwipeDirection:
                  const AllowedSwipeDirection.only(left: true, right: true),
              onSwipe: (prev, curr, dir) =>
                  _onSwipe(prev, curr, dir, userList, jobId),
              cardBuilder: (context, index, pctX, pctY) {
                CardSwiperDirection? liveDir;
                const threshold = 0.12;
                if (pctX > threshold) liveDir = CardSwiperDirection.right;
                if (pctX < -threshold) liveDir = CardSwiperDirection.left;
                return _UserCard(user: userList[index], liveDirection: liveDir);
              },
              isLoop: true,
            ),
          ),
        ),

        // ─── FAB row ──────────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.only(bottom: 28.h, top: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fab(
                icon: Icons.close_rounded,
                color: _reject,
                size: 58,
                label: 'Skip',
                onTap: () => controller.swipe(CardSwiperDirection.left),
              ),
              SizedBox(width: 20.w),
              _fab(
                icon: Icons.replay_rounded,
                color: Colors.grey.shade400,
                size: 46,
                label: 'Undo',
                onTap: controller.undo,
                outlined: true,
              ),
              SizedBox(width: 20.w),
              _fab(
                icon: Icons.favorite_rounded,
                color: _accept,
                size: 58,
                label: 'Match',
                onTap: () => controller.swipe(CardSwiperDirection.right),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fab({
    required IconData icon,
    required Color color,
    required double size,
    required String label,
    required VoidCallback onTap,
    bool outlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              color: outlined ? Colors.white : color,
              shape: BoxShape.circle,
              border: outlined
                  ? Border.all(color: Colors.grey.shade300, width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: outlined
                      ? Colors.black.withOpacity(0.06)
                      : color.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon,
                color: outlined ? Colors.grey.shade400 : Colors.white,
                size: size * 0.44),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: outlined ? Colors.grey : color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// User Card — white card with photo + info
// ═══════════════════════════════════════════════════════════════════════════
class _UserCard extends StatelessWidget {
  final SwipedRes user;
  final CardSwiperDirection? liveDirection;

  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _navy = Color(0xFF040326);
  static const Color _accept = Color(0xFF2DB67D);
  static const Color _reject = Color(0xFFE8505B);
  static const Color _orange = Color(0xFFf55631);

  const _UserCard({required this.user, this.liveDirection});

  @override
  Widget build(BuildContext context) {
    final isRight = liveDirection == CardSwiperDirection.right;
    final isLeft = liveDirection == CardSwiperDirection.left;
    final hasOverlay = liveDirection != null;

    return Container(
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              // ── Photo — top 62% ────────────────────────────────────────
              Expanded(
                flex: 62,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      user.profile,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _teal.withOpacity(0.08),
                        child: const Icon(Icons.person_rounded,
                            color: _teal, size: 64),
                      ),
                    ),
                    // Gradient fade to navy at bottom
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              _navy.withOpacity(0.6),
                              _navy,
                            ],
                            stops: const [0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info — bottom 38% ──────────────────────────────────────
              Expanded(
                flex: 38,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Location
                      if (user.location.isNotEmpty) ...[
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: _orange, size: 13),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                user.location,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white60,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 12.h),

                      // Skills
                      if (user.skills.isNotEmpty)
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: user.skills.take(6).map((skill) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 11.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: _teal.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: _teal.withOpacity(0.25), width: 1),
                                ),
                                child: Text(
                                  skill,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: _teal,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      else
                        Text(
                          'No skills listed',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white30,
                              fontFamily: 'Poppins'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Swipe overlay ──────────────────────────────────────────────
          if (hasOverlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: (isRight ? _accept : _reject).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                    color: isRight ? _accept : _reject,
                    width: 2.5,
                  ),
                ),
                child: Align(
                  alignment: isRight ? Alignment.topRight : Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 28.h,
                      left: isLeft ? 20.w : 0,
                      right: isRight ? 20.w : 0,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isRight ? _accept : _reject,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRight
                                ? Icons.favorite_rounded
                                : Icons.close_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            isRight ? 'MATCH' : 'SKIP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
