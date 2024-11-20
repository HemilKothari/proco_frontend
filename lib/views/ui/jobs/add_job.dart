import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/reusable_text.dart';
import 'package:provider/provider.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  // Form controllers
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final companyController = TextEditingController();
  final descriptionController = TextEditingController();
  final salaryController = TextEditingController();
  final imageUrlController = TextEditingController();
  bool isHiring = true;

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    companyController.dispose();
    descriptionController.dispose();
    salaryController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void submitJob() {
    if (titleController.text.isEmpty ||
        locationController.text.isEmpty ||
        companyController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        salaryController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    // Example job data to send to the backend
    final jobData = {
      'title': titleController.text,
      'location': locationController.text,
      'company': companyController.text,
      'description': descriptionController.text,
      'salary': salaryController.text,
      'hiring': isHiring,
      'imageUrl': imageUrlController.text,
    };

    // TODO: Call the API to send `jobData` to the backend
    print('Query Data: $jobData');

    // Reset the form
    setState(() {
      titleController.clear();
      locationController.clear();
      companyController.clear();
      descriptionController.clear();
      salaryController.clear();
      imageUrlController.clear();
      isHiring = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'List Query',
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<LoginNotifier>(
        builder: (context, loginNotifier, child) {
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
                      hintText: 'Query Title',
                      keyboardType: TextInputType.text,
                      validator: (title) {
                        if (title!.isEmpty) {
                          return 'Please enter a valid job title';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: locationController,
                      hintText: 'Location',
                      keyboardType: TextInputType.text,
                      validator: (location) {
                        if (location!.isEmpty) {
                          return 'Please enter a valid location';
                        } else {
                          return null;
                        }
                      },
                    ),

                    /*const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: companyController,
                      hintText: 'Company',
                      keyboardType: TextInputType.text,
                      validator: (company) {
                        if (company!.isEmpty) {
                          return 'Please enter a valid company';
                        } else {
                          return null;
                        }
                      },
                    ), */
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      keyboardType: TextInputType.text,
                      validator: (description) {
                        if (description!.isEmpty) {
                          return 'Please enter a valid description';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: salaryController,
                      hintText: 'Reward/Compensation',
                      keyboardType: TextInputType.number,
                      validator: (salary) {
                        if (salary!.isEmpty) {
                          return 'Please enter a valid salary';
                        } else {
                          return null;
                        }
                      },
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
                      validator: (url) {
                        if (url!.isEmpty) {
                          return 'Please enter a valid image URL';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 20),
                    CustomButton(
                      onTap: submitJob,
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
