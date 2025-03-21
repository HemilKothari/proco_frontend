import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:jobhub_v1/views/common/width_spacer.dart';
import 'package:provider/provider.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({
    super.key,
  });

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController(); // City field
  TextEditingController state = TextEditingController(); // State field
  TextEditingController country = TextEditingController(); // Country field
  TextEditingController college = TextEditingController(); // College field
  TextEditingController branch = TextEditingController(); // Branch field
  TextEditingController skill0 = TextEditingController();
  TextEditingController skill1 = TextEditingController();
  TextEditingController skill2 = TextEditingController();
  TextEditingController skill3 = TextEditingController();
  TextEditingController skill4 = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  @override
  void dispose() {
    phone.dispose();
    city.dispose();
    state.dispose();
    country.dispose();
    college.dispose();
    branch.dispose();
    skill0.dispose();
    skill1.dispose();
    skill2.dispose();
    skill3.dispose();
    skill4.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageUpoader imageUploader) async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Or ImageSource.camera
    if (pickedFile != null) {
      imageUploader.imageFil
          .add(pickedFile.path); // Add picked image path to imageUploader
      setState(() {}); // Rebuild to show the picked image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'Update Profile',
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: const Color(0xFF08979F),
              size: 20,
            ),
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
                    text: 'Personal Details',
                    style: appstyle(35, Color(kDark.value), FontWeight.bold),
                  ),
                  Consumer<ImageUpoader>(
                    builder: (context, imageUploader, child) {
                      return imageUploader.imageFil.isEmpty
                          ? GestureDetector(
                              onTap: () => _pickImage(imageUploader),
                              child: CircleAvatar(
                                backgroundColor: Color(kLightBlue.value),
                                child: const Center(
                                  child: Icon(Icons.photo_filter_rounded),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                imageUploader.imageFil.clear();
                                setState(() {});
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(kLightBlue.value),
                                backgroundImage:
                                    FileImage(File(imageUploader.imageFil[0])),
                              ),
                            );
                    },
                  ),
                ],
              ),
              const HeightSpacer(size: 20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: city,
                            hintText: 'City',
                            keyboardType: TextInputType.text,
                            validator: (city) {
                              if (city!.isEmpty) {
                                return 'Please enter a valid city';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const WidthSpacer(width: 10),
                        Expanded(
                          child: CustomTextField(
                            controller: state,
                            hintText: 'State',
                            keyboardType: TextInputType.text,
                            validator: (state) {
                              if (state!.isEmpty) {
                                return 'Please enter a valid state';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const WidthSpacer(width: 10),
                        Expanded(
                          child: CustomTextField(
                            controller: country,
                            hintText: 'Country',
                            keyboardType: TextInputType.text,
                            validator: (country) {
                              if (country!.isEmpty) {
                                return 'Please enter a valid country';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: phone,
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (phone) {
                        if (phone!.isEmpty) {
                          return 'Please enter a valid phone';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: college,
                      hintText: 'College',
                      keyboardType: TextInputType.text,
                      validator: (college) {
                        if (college!.isEmpty) {
                          return 'Please enter a valid college name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: branch,
                      hintText: 'Branch',
                      keyboardType: TextInputType.text,
                      validator: (branch) {
                        if (branch!.isEmpty) {
                          return 'Please enter a valid branch';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    ReusableText(
                      text: 'Professional Skills',
                      style: appstyle(30, Color(kDark.value), FontWeight.bold),
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: skill0,
                      hintText: 'Professional Skill 1',
                      keyboardType: TextInputType.text,
                      validator: (skill0) {
                        if (skill0!.isEmpty) {
                          return 'Please enter a valid skill';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: skill1,
                      hintText: 'Professional Skill 2',
                      keyboardType: TextInputType.text,
                      validator: (skill1) {
                        if (skill1!.isEmpty) {
                          return 'Please enter a valid skill';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 10),
                    CustomTextField(
                      controller: skill2,
                      hintText: 'Professional Skill 3',
                      keyboardType: TextInputType.text,
                      validator: (skill2) {
                        if (skill2!.isEmpty) {
                          return 'Please enter a valid skill';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const HeightSpacer(size: 20),
                    Consumer<ImageUpoader>(
                      builder: (context, imageUploader, child) {
                        return CustomButton(
                          onTap: () {
                            // Check if image is missing and assign the default image URL
                            String profileImage = imageUploader
                                    .imageFil.isNotEmpty
                                ? imageUploader
                                    .imageFil[0] // Use the picked image
                                : "https://www.pngplay.com/wp-content/uploads/12/User-Avatar-Profile-Clip-Art-Transparent-PNG.png"; // Default image URL

                            final model = ProfileUpdateReq(
                              city: city.text,
                              state: state.text,
                              country: country.text,
                              phone: phone.text,
                              profile:
                                  profileImage, // Use the profile image (either uploaded or default)
                              skills: [
                                skill0.text,
                                skill1.text,
                                skill2.text,
                              ],
                              college: college.text,
                              branch: branch.text,
                            );

                            loginNotifier.updateProfile(
                                model); // Call the update function
                          },
                          text: 'Update Profile',
                        );
                      },
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
