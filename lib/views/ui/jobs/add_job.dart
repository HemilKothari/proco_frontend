import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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

  void addRequirementField() {
    setState(() {
      requirementsControllers.add(TextEditingController());
    });
  }

  void removeRequirementField(int index) {
    setState(() {
      requirementsControllers[index].dispose();
      requirementsControllers.removeAt(index);
    });
  }

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'List Query',
          child: Padding(
            padding: EdgeInsets.all(10.0.h),
            child: IconButton(
              icon: const Icon(
                FontAwesome.arrow_left,
                color: Color(0xFF08959D),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Consumer<JobsNotifier>(
        builder: (context, JobsNotifier, child) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                    text: 'Query Details',
                    style: appstyle(35, Color(kDark.value), FontWeight.bold),
                  ),
                ],
              ),
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
            ],
          );
        },
      ),
    );
  }
}
