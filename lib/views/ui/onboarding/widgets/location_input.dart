import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';

class LocationInputPage extends StatefulWidget {
  final String name;
  final String profession;

  const LocationInputPage({required this.name, required this.profession});

  @override
  State<LocationInputPage> createState() => _LocationInputPageState();
}

class _LocationInputPageState extends State<LocationInputPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title and Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50), // For spacing at the top
                  Text(
                    "Hi ${widget.name}, let's complete your profile.",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please enter your location details.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Location Input Fields
              Column(
                children: [
                  _buildLocationField(
                    controller: _cityController,
                    hintText: "City",
                  ),
                  SizedBox(height: 20),
                  _buildLocationField(
                    controller: _stateController,
                    hintText: "State",
                  ),
                  SizedBox(height: 20),
                  _buildLocationField(
                    controller: _countryController,
                    hintText: "Country",
                  ),
                ],
              ),

              // Next Button
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_cityController.text.isNotEmpty &&
                            _stateController.text.isNotEmpty &&
                            _countryController.text.isNotEmpty) {
                          // Handle next steps, like saving location details
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill all fields."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.black, // Hinge-like button color
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Save Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Optional: Handle back action
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Location Input Field
  Widget _buildLocationField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return CustomTextField(
      controller: controller,
      keyboardType: TextInputType.text,
      hintText: hintText,
    );
  }
}
