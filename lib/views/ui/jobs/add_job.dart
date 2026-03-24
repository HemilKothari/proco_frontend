import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/reusable_text.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/services/helpers/user_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  // ─── Theme ────────────────────────────────────────────────────────────────
  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _navy = Color(0xFF040326);
  static const Color _bg = Colors.white;

  // ─── Controllers ──────────────────────────────────────────────────────────
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _contractController = TextEditingController();
  final _periodController = TextEditingController();
  List<TextEditingController> _reqControllers = [TextEditingController()];
  bool _isHiring = true;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _imageUrlController.dispose();
    _contractController.dispose();
    _periodController.dispose();
    for (final c in _reqControllers) c.dispose();
  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final descriptionController = TextEditingController();
  final salaryController = TextEditingController();
  final imageUrlController = TextEditingController();
  final contractController = TextEditingController();
  final periodController = TextEditingController();

  List<TextEditingController> requirementsControllers = [
    TextEditingController()
  ];

  bool isHiring = true;
  String? selectedCategory;
  String? selectedOpportunityType;

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    descriptionController.dispose();
    salaryController.dispose();
    imageUrlController.dispose();
    contractController.dispose();
    periodController.dispose();
    for (var controller in requirementsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addRequirement() =>
      setState(() => _reqControllers.add(TextEditingController()));

  void _removeRequirement(int index) => setState(() {
        _reqControllers[index].dispose();
        _reqControllers.removeAt(index);
      });

  Future<void> _submit(JobsNotifier notifier) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    final jobData = CreateJobsRequest(
      title: _titleController.text,
      location: _locationController.text,
      company: _companyController.text,
      description: _descriptionController.text,
      salary: _salaryController.text,
      period: _periodController.text,
      hiring: _isHiring,
      contract: _contractController.text,
      requirements: _reqControllers.map((c) => c.text).toList(),
      imageUrl: _imageUrlController.text,
      agentId: userId,
      matchedUsers: [],
      swipedUsers: [],
    );

    if (!mounted) return;
    notifier.createJob(jobData, context);
  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade500)),
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'Add Job Listing',
          child: Padding(
            padding: EdgeInsets.all(10.0.h),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _teal),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Consumer<JobsNotifier>(
        builder: (context, jobsNotifier, child) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: [
              // ── Page title ───────────────────────────────────────────────
              Text(
                'Job Details',
                style: appstyle(28, const Color(0xFF040326), FontWeight.w700),
              ),
              SizedBox(height: 4.h),
              Text(
                'Fill in the details to post a new listing',
                style: appstyle(13, Colors.grey, FontWeight.w400),
              ),
              SizedBox(height: 24.h),

              // ── Section: Basic Info ───────────────────────────────────────
              _sectionLabel('Basic Info'),
              SizedBox(height: 12.h),
              _field(_titleController, 'Job Title', Icons.work_outline_rounded),
              SizedBox(height: 12.h),
              _field(_companyController, 'Company', Icons.business_outlined),
              SizedBox(height: 12.h),
              _field(
                  _locationController, 'Location', Icons.location_on_outlined),
              SizedBox(height: 24.h),

              // ── Section: Compensation ─────────────────────────────────────
              _sectionLabel('Compensation'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _field(_salaryController, 'Salary / Reward',
                        Icons.payments_outlined,
                        keyboardType: TextInputType.number),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _field(
                        _periodController, 'Period', Icons.timelapse_rounded),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _field(
                  _contractController, 'Contract Type', Icons.article_outlined),
              SizedBox(height: 24.h),

              // ── Section: Description ──────────────────────────────────────
              _sectionLabel('Description'),
              SizedBox(height: 12.h),
              _field(
                _descriptionController,
                'Describe the role…',
                Icons.description_outlined,
                maxLines: 4,
              ),
              SizedBox(height: 24.h),

              // ── Section: Requirements ─────────────────────────────────────
              _sectionLabel('Requirements'),
              SizedBox(height: 12.h),
              ..._reqControllers.asMap().entries.map((entry) {
                final i = entry.key;
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _field(
                          entry.value,
                          'Requirement ${i + 1}',
                          Icons.check_circle_outline_rounded,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () => _removeRequirement(i),
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Colors.redAccent, size: 18),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Add requirement button
              GestureDetector(
                onTap: _addRequirement,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: _teal.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _teal.withOpacity(0.25),
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_circle_outline_rounded,
                          color: _teal, size: 18),
                      SizedBox(width: 8.w),
                      Text('Add Requirement',
                          style: appstyle(13, _teal, FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Section: Settings ─────────────────────────────────────────
              _sectionLabel('Settings'),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (_isHiring ? Colors.green : Colors.red)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _isHiring
                            ? Icons.check_circle_outline_rounded
                            : Icons.cancel_outlined,
                        color: _isHiring ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hiring Status',
                              style: appstyle(14, _navy, FontWeight.w600)),
                          Text(
                            _isHiring
                                ? 'Actively accepting applicants'
                                : 'Position is closed',
                            style: appstyle(11, Colors.grey, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isHiring,
                      onChanged: (v) => setState(() => _isHiring = v),
                      activeColor: _teal,
              const HeightSpacer(size: 20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: titleController,
                      hintText: 'Query Title (optional)',
                      keyboardType: TextInputType.text,
                    ),
                    const HeightSpacer(size: 10),
                    // Domain / Category dropdown
                    Text(
                      'Domain',
                      style: appstyle(14, Colors.black87, FontWeight.w600),
                    ),
                    const HeightSpacer(size: 6),
                    _buildDropdown(
                      hint: 'Select Domain',
                      items: kDomains,
                      value: selectedCategory,
                      onChanged: (val) => setState(() => selectedCategory = val),
                    ),
                    const HeightSpacer(size: 10),
                    // Opportunity Type dropdown
                    Text(
                      'Opportunity Type',
                      style: appstyle(14, Colors.black87, FontWeight.w600),
                    ),
                    const HeightSpacer(size: 6),
                    _buildDropdown(
                      hint: 'Select Opportunity Type',
                      items: kOpportunityTypes,
                      value: selectedOpportunityType,
                      onChanged: (val) =>
                          setState(() => selectedOpportunityType = val),
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: companyController,
                      hintText: 'Company (optional)',
                      keyboardType: TextInputType.text,
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description (optional)',
                      keyboardType: TextInputType.text,
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: salaryController,
                      hintText: 'Reward/Compensation (optional)',
                      keyboardType: TextInputType.number,
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: periodController,
                      hintText: 'Period (optional)',
                      keyboardType: TextInputType.text,
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: contractController,
                      hintText: 'Contract (optional)',
                      keyboardType: TextInputType.text,
                    ),
                    const HeightSpacer(size: 10),
                    Text(
                      'Requirements',
                      style: appstyle(18, Colors.black, FontWeight.bold),
                    ),
                    const HeightSpacer(size: 10),
                    Column(
                      children: List.generate(
                        requirementsControllers.length,
                        (index) => Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: requirementsControllers[index],
                                hintText: 'Requirement ${index + 1}',
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeRequirementField(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    TextButton.icon(
                      onPressed: addRequirementField,
                      icon: const Icon(Icons.add, color: Colors.green),
                      label: Text(
                        'Add Requirement',
                        style: appstyle(16, Colors.green, FontWeight.bold),
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Query Status'),
                        Switch(
                          value: isHiring,
                          onChanged: (value) {
                            setState(() {
                              isHiring = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: imageUrlController,
                      hintText: 'Image URL',
                      keyboardType: TextInputType.text,
                    ),
                    const HeightSpacer(size: 20),
                    CustomButton(
                      onTap: () async {
                        if (selectedCategory == null ||
                            selectedOpportunityType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select a domain and opportunity type.'),
                            ),
                          );
                          return;
                        }

                        try {
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getString('userId') ?? '';

                          if (userId.isEmpty) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'You must be logged in to list a query.')),
                            );
                            return;
                          }

                          ProfileRes? profile;
                          try {
                            profile = await UserHelper.getProfile();
                          } catch (_) {
                            profile = null;
                          }
                          final location = profile?.location ?? '';
                          final requirementsList = requirementsControllers
                              .map((c) => c.text)
                              .where((t) => t.trim().isNotEmpty)
                              .toList();

                          final jobData = CreateJobsRequest(
                            agentId: userId,
                            domain: selectedCategory!,
                            opportunityType: selectedOpportunityType!,
                            title: titleController.text.isNotEmpty
                                ? titleController.text
                                : selectedCategory!,
                            location: location.isNotEmpty ? location : 'Remote',
                            company: companyController.text,
                            description: descriptionController.text,
                            salary: salaryController.text,
                            period: periodController.text,
                            hiring: isHiring,
                            contract: contractController.text,
                            requirements: requirementsList,
                            imageUrl: imageUrlController.text,
                            matchedUsers: [],
                            swipedUsers: [],
                          );

                          if (!mounted) return;
                          await JobsNotifier.createJob(jobData, context);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      text: 'List Query',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // ── Section: Media ────────────────────────────────────────────
              _sectionLabel('Media'),
              SizedBox(height: 12.h),
              _field(_imageUrlController, 'Image URL', Icons.image_outlined),
              SizedBox(height: 32.h),

              // ── Submit button ─────────────────────────────────────────────
              GestureDetector(
                onTap: () => _submit(jobsNotifier),
                child: Container(
                  width: double.infinity,
                  height: 54.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_teal, _tealLt],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _teal.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Post Listing',
                      style: appstyle(16, Colors.white, FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          );
        },
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18.h,
          decoration: BoxDecoration(
            color: _teal,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 10.w),
        Text(text, style: appstyle(15, _navy, FontWeight.w700)),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: appstyle(14, _navy, FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: appstyle(14, Colors.grey.shade400, FontWeight.w400),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            child: Icon(icon, color: _teal, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _teal, width: 1.5),
          ),
        ),
      ),
    );
  }
}
