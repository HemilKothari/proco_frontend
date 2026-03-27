import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/controllers/image_provider.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/ui/auth/edit_tab.dart';
import 'package:jobhub_v1/views/ui/auth/profile_state.dart';
import 'package:jobhub_v1/views/ui/auth/view_tab.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  static const Color _bg = Color(0xFF040326);
  static const Color _teal = kTeal;
  static const Color _white = Colors.white;

  late TabController _tabController;
  int _activeTab = 0; // 0 = View, 1 = Edit

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _activeTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileEditState()),
        ChangeNotifierProvider(create: (_) => ImageNotifier()),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: _bg,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.065.sh),
            child: CustomAppBar(
              text: 'Profile',
              child: Padding(
                padding: EdgeInsets.only(left: 0.010.sh),
                child: const DrawerWidget(),
              ),
            ),
          ),
          body: Consumer<ProfileEditState>(
            builder: (context, state, _) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: _teal),
                );
              }
              if (state.error != null && state.error!.contains('Could not')) {
                return _buildErrorView(state);
              }
              return Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        ViewTab(),
                        EditTab(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _tabPill(0, 'View'),
            _tabPill(1, 'Edit'),
          ],
        ),
      ),
    );
  }

  Widget _tabPill(int index, String label) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
          setState(() => _activeTab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? _teal : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _teal.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? _white : Colors.white38,
                fontSize: 14.sp,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(ProfileEditState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 60, color: _teal.withOpacity(0.6)),
          SizedBox(height: 16.h),
          Text(
            state.error ?? 'Something went wrong',
            textAlign: TextAlign.center,
            style: TextStyle(color: _white, fontSize: 15.sp),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: state.loadProfile,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: _teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                    color: _white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
