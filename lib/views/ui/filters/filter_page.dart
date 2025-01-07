import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Controller for the text fields
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _opportunityController = TextEditingController();

  // Initial data for each filter
  final List<String> _locations = [
    'New York',
    'San Francisco',
    'London',
    'Berlin'
  ];
  final List<String> _skills = [
    'Flutter',
    'React',
    'Dart',
    'Node.js',
    'Python'
  ];
  final List<String> _opportunityTypes = [
    'Full-time',
    'Part-time',
    'Internship',
    'Freelance'
  ];

  // Filtered results
  List<String> _filteredLocations = [];
  List<String> _filteredSkills = [];
  List<String> _filteredOpportunityTypes = [];

  // Update filtered results based on the user input
  void _filterResults() {
    setState(() {
      _filteredLocations = _locations
          .where((location) => location
              .toLowerCase()
              .contains(_locationController.text.toLowerCase()))
          .toList();
      _filteredSkills = _skills
          .where((skill) =>
              skill.toLowerCase().contains(_skillController.text.toLowerCase()))
          .toList();
      _filteredOpportunityTypes = _opportunityTypes
          .where((opportunity) => opportunity
              .toLowerCase()
              .contains(_opportunityController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // Initializing the filtered lists
    _filteredLocations = _locations;
    _filteredSkills = _skills;
    _filteredOpportunityTypes = _opportunityTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Color(0xFF08959D), // Title color
            fontFamily: 'Poppins', // Font family
          ),
        ),
        backgroundColor: const Color(0xFF040326),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF08959D), // Back button color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Location Filter
            TextField(
              controller: _locationController,
              onChanged: (value) => _filterResults(),
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'Type to filter locations',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF040326),
                labelStyle: const TextStyle(
                  color: Color(0xFF08959D),
                  fontFamily: 'Poppins',
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            _buildFilteredList(_filteredLocations),
            const SizedBox(height: 20),

            // Skill Filter
            TextField(
              controller: _skillController,
              onChanged: (value) => _filterResults(),
              decoration: InputDecoration(
                labelText: 'Skills',
                hintText: 'Type to filter skills',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF040326),
                labelStyle: const TextStyle(
                  color: Color(0xFF08959D),
                  fontFamily: 'Poppins',
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            _buildFilteredList(_filteredSkills),
            const SizedBox(height: 20),

            // Opportunity Type Filter
            TextField(
              controller: _opportunityController,
              onChanged: (value) => _filterResults(),
              decoration: InputDecoration(
                labelText: 'Opportunity Type',
                hintText: 'Type to filter opportunity types',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF040326),
                labelStyle: const TextStyle(
                  color: Color(0xFF08959D),
                  fontFamily: 'Poppins',
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            _buildFilteredList(_filteredOpportunityTypes),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle submit action (e.g., apply filters)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Filters applied')),
                );
              },
              child: const Text('Apply Filters'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF08959D),
                textStyle: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredList(List<String> filteredList) {
    return Column(
      children: filteredList
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ))
          .toList(),
    );
  }
}
