import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/views/ui/auth/signup.dart';
import 'package:jobhub_v1/views/ui/homepage.dart';
// Import the HomePage

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final TextEditingController cityController = TextEditingController();
  String? selectedState;
  String? selectedCountry;

  // Example lists for dropdowns
  final List<String> states = ['Maharashtra', 'Tamil Nadu', 'Rajasthan'];
  final List<String> countries = ['India', 'USA', 'UK'];

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF08979F), Color(0xFF040326)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Location Details',
                style: TextStyle(
                  fontSize: 26.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: cityController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter City',
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 16),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedState,
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                  });
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  hintText: 'Select your State',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                dropdownColor: Colors.white70,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  hintText: 'Select your Country',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                dropdownColor: Colors.white70,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                    onTap: () {
                      if (cityController.text.isNotEmpty &&
                          selectedState != null &&
                          selectedCountry != null) {
                        // Navigate to HomePage
                        Get.offAll(() => RegistrationPage());
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please fill all fields',
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                      }
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
