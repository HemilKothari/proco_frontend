import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/ui/onboarding/widgets/location_input.dart';

class ProfessionSelectionPage extends StatefulWidget {
  final String name;

  const ProfessionSelectionPage({required this.name});

  @override
  State<ProfessionSelectionPage> createState() =>
      _ProfessionSelectionPageState();
}

class _ProfessionSelectionPageState extends State<ProfessionSelectionPage> {
  String? selectedProfession;

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
                    "Choose your profession.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Profession Selection
              Column(
                children: [
                  _buildProfessionOption('Student'),
                  _buildProfessionOption('Working Professional'),
                  _buildProfessionOption('Freelancer'),
                ],
              ),

              // Next Button
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedProfession != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationInputPage(
                                name: widget.name,
                                profession: selectedProfession!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a profession."),
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
                        "Next",
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

  // Widget for Profession Option
  Widget _buildProfessionOption(String profession) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfession = profession;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedProfession == profession
              ? Colors.black
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedProfession == profession
                ? Colors.transparent
                : Colors.black,
          ),
        ),
        child: Text(
          profession,
          style: TextStyle(
            fontSize: 16,
            color:
                selectedProfession == profession ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
