import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub_v1/controllers/signup_provider.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    collegeController.dispose();
    branchController.dispose();
    genderController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpNotifier(),
      child: Consumer<SignUpNotifier>(
        builder: (context, signUpProvider, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.065.sh),
              child: CustomAppBar(
                text: 'Sign Up',
                child: GestureDetector(
                  onTap: () {
                    if (signUpProvider.activeIndex > 0) {
                      signUpProvider.changeStep(signUpProvider.activeIndex - 1);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: const Color(0xFF08979F),
                    size: 20,
                  ),
                ),
              ),
            ),
            body: IndexedStack(
              index: signUpProvider.activeIndex,
              children: [
                _namePage(signUpProvider),
                _emailPage(signUpProvider),
                _passwordPage(signUpProvider),
                _collegePage(signUpProvider),
                _genderPage(signUpProvider),
                _locationPage(signUpProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Step 1: Full Name
  Widget _namePage(SignUpNotifier signUpProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF08979F), const Color(0xFF040326)],
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
                "What should other\nProfessionals call you?",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              CustomTextFieldInput(
                controller: nameController,
                hintText: 'Full Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () {
                      signUpProvider.signupModel.username = nameController.text;
                      signUpProvider.changeStep(1);
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Step 2: Email
  Widget _emailPage(SignUpNotifier signUpProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF08979F), const Color(0xFF040326)],
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
                "What's your email?",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              CustomTextFieldInput(
                controller: emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () {
                      signUpProvider.signupModel.email = emailController.text;
                      signUpProvider.changeStep(2);
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Step 3: Password
  Widget _passwordPage(SignUpNotifier signUpProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF08979F), const Color(0xFF040326)],
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
                "Create a secure password",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              CustomTextFieldInput(
                controller: passwordController,
                hintText: 'Password',
                keyboardType: TextInputType.text,
                obscureText: signUpProvider.obscureText,
                validator: (password) {
                  if (!signUpProvider.passwordValidator(password!)) {
                    return 'At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character.';
                  }
                  return null;
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    signUpProvider.obscureText = !signUpProvider.obscureText;
                  },
                  child: Icon(
                    signUpProvider.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () {
                      if (!signUpProvider
                          .passwordValidator(passwordController.text)) {
                        Get.snackbar(
                          'Invalid Password',
                          'Password must have at least one uppercase, one lowercase, one digit, and one special character.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        signUpProvider.signupModel.password =
                            passwordController.text;
                        signUpProvider.changeStep(3);
                      }
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Step 4: College & Branch
  Widget _collegePage(SignUpNotifier signUpProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF08979F), const Color(0xFF040326)],
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
                "Which College do you belong to?",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              CustomTextFieldInput(
                controller: collegeController,
                hintText: 'College',
                keyboardType: TextInputType.text,
              ),
              CustomTextFieldInput(
                controller: branchController,
                hintText: 'Branch',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () {
                      signUpProvider.signupModel.college =
                          collegeController.text;
                      signUpProvider.signupModel.branch = branchController.text;
                      signUpProvider.changeStep(4);
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Step 5: Gender
  Widget _genderPage(SignUpNotifier signUpProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF08979F), const Color(0xFF040326)],
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
                "Please specify your Gender",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              CustomTextFieldInput(
                controller: genderController,
                hintText: 'Gender',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () {
                      signUpProvider.signupModel.gender = genderController.text;
                      signUpProvider.changeStep(5);
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Step 6: Location (City, State, Country)
  Widget _locationPage(SignUpNotifier signUpProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF08979F), const Color(0xFF040326)],
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
                "Enter Location details",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              CustomTextFieldInput(
                controller: cityController,
                hintText: 'City',
                keyboardType: TextInputType.text,
              ),
              CustomTextFieldInput(
                controller: stateController,
                hintText: 'State',
                keyboardType: TextInputType.text,
              ),
              CustomTextFieldInput(
                controller: countryController,
                hintText: 'Country',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () {
                      signUpProvider.signupModel.city = cityController.text;
                      signUpProvider.signupModel.state = stateController.text;
                      signUpProvider.signupModel.country =
                          countryController.text;
                      signUpProvider.submitSignup();
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
