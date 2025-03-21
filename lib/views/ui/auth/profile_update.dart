import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/services/helpers/auth_helper.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  List<String> skills = [];
  final TextEditingController _skillController = TextEditingController();

  bool isLoading = true;
  bool isUpdating = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _collegeController.dispose();
    _branchController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      debugPrint("Loading profile data...");
      final profileData = await AuthHelper.getProfile();

      if (profileData != null) {
        debugPrint("Profile data loaded successfully");
        setState(() {
          _cityController.text = profileData.city ?? '';
          _stateController.text = profileData.state ?? '';
          _countryController.text = profileData.country ?? '';
          _phoneController.text = profileData.phone ?? '';
          _collegeController.text = profileData.college ?? '';
          _branchController.text = profileData.branch ?? '';
          skills = List<String>.from(profileData.skills ?? []);
        });
      } else {
        debugPrint("Profile data is null");
        setState(() {
          errorMessage = "Could not load profile data";
        });
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      setState(() {
        errorMessage = "Error loading profile: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isUpdating = true;
        errorMessage = null;
      });

      debugPrint("Updating profile...");

      try {
        // Validate phone number format
        final phoneNumber = _phoneController.text.trim();
        if (phoneNumber.isEmpty || !isValidPhoneNumber(phoneNumber)) {
          throw Exception("Please enter a valid phone number");
        }

        final updateReq = ProfileUpdateReq(
          city: _cityController.text,
          state: _stateController.text,
          country: _countryController.text,
          phone: phoneNumber,
          profile:
              null, // You can implement profile picture functionality separately
          skills: skills,
          college: _collegeController.text,
          branch: _branchController.text,
        );

        debugPrint("Profile update data: ${updateReq.toJson()}");

        final response = await AuthHelper.updateProfile(updateReq);

        if (response == true) {
          debugPrint("Profile updated successfully");
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 3),
          );

          // Navigate to main screen after delay
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            debugPrint("Navigating to MainScreen");
            Get.offAll(() => const MainScreen());
          }
        } else {
          debugPrint("Profile update failed");
          setState(() {
            errorMessage = "Profile update failed. Please try again.";
          });

          Get.snackbar(
            'Update Failed',
            'Please check your information and try again',
            colorText: Colors.white,
            backgroundColor: Colors.orange,
            icon: const Icon(Icons.warning, color: Colors.white),
            duration: const Duration(seconds: 4),
          );
        }
      } catch (e) {
        debugPrint("Error updating profile: $e");

        setState(() {
          errorMessage = "Error: ${e.toString()}";
        });

        Get.snackbar(
          'Error',
          'An error occurred: ${e.toString()}',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        if (mounted) {
          setState(() {
            isUpdating = false;
          });
        }
      }
    } else {
      debugPrint("Form validation failed");
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields correctly',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  // Basic phone validation
  bool isValidPhoneNumber(String phone) {
    // This is a simple validation, enhance as needed
    return phone.length >= 10 && RegExp(r'^\d{10,15}$').hasMatch(phone);
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !skills.contains(skill)) {
      setState(() {
        skills.add(skill);
        _skillController.clear();
      });
      debugPrint("Added skill: $skill");
    } else if (skills.contains(skill)) {
      Get.snackbar(
        'Duplicate Skill',
        'This skill is already in your list',
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadProfile,
            tooltip: 'Reload Profile',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null &&
                  errorMessage!.contains("Could not load profile data")
              ? _buildErrorView()
              : _buildFormView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProfile,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message if any
            if (errorMessage != null &&
                !errorMessage!.contains("Could not load profile data"))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),

            // Personal Information
            _buildSectionHeader('Personal Information'),

            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                hintText: 'Enter your 10-digit phone number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!isValidPhoneNumber(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Location
            _buildSectionHeader('Location'),

            // City
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // State
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'State *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your state';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Country
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.public),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your country';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Education
            _buildSectionHeader('Education'),

            // College
            TextFormField(
              controller: _collegeController,
              decoration: const InputDecoration(
                labelText: 'College',
                hintText: 'Enter your college/university name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 16),

            // Branch
            TextFormField(
              controller: _branchController,
              decoration: const InputDecoration(
                labelText: 'Branch',
                hintText: 'Enter your field of study',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.subject),
              ),
            ),
            const SizedBox(height: 16),

            // Skills
            _buildSectionHeader('Skills'),

            // Add Skills
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _skillController,
                    decoration: const InputDecoration(
                      labelText: 'Add a skill',
                      hintText: 'e.g., Flutter, React, Project Management',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.psychology),
                    ),
                    onFieldSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addSkill,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display Skills
            _buildSkillsList(),
            const SizedBox(height: 24),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUpdating ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: isUpdating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Updating...', style: TextStyle(fontSize: 16)),
                        ],
                      )
                    : const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSkillsList() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skills.isEmpty
                ? 'No skills added yet'
                : 'Your Skills (${skills.length})',
            style: TextStyle(
              color: skills.isEmpty ? Colors.grey : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: Colors.blue.shade100,
                deleteIconColor: Colors.blue.shade700,
                onDeleted: () {
                  setState(() {
                    skills.remove(skill);
                  });
                  debugPrint("Removed skill: $skill");
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
