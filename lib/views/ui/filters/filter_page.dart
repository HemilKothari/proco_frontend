import 'package:flutter/material.dart';
import 'package:jobhub_v1/controllers/filter_provider.dart';
import 'package:jobhub_v1/models/request/filters/create_filter.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/homepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // List of options for the bubbles
  final List<String> options = [
    'Web Development',
    'App Development',
    'Graphic Designer',
    'Fianace',
    'Consulting',
    'Marketing',
    'Competitive Programming',
    'Cyber Security',
    'Blockchain',
    'Research',
    'UI/UX',
    'Animator',
  ];
  final Map<String, bool> opportunityTypes = {
    'Internship': false,
    'Research': false,
    'Freelance': false,
    'Competition': false,
  };

  final List<String> states = [
    "California",
    "Texas",
    "Florida",
    "New York",
    "Illinois",
    "Pennsylvania",
    "Ohio",
    "Georgia",
    "North Carolina",
    "Michigan"
  ]; // List of states

  List<TextEditingController> customControllers =
      List.generate(10, (index) => TextEditingController());

  // Store the selected options
  final List<String> selectedOptions = [];
  bool showCustomInput = false; // Flag to show/hide custom input
  // String customInputValue = ""; // Store the custom input value
  double selectedDistance = 10.0;
  String selectedLocationOption =
      ""; // Keeps track of the selected option (City/State/Country)
  double locationDistance = 10.0; // For City Slider
  String selectedState = ""; // For State Dropdown
  String enteredCountry = ""; // For Country Text Input

  void removeCustomField(int index) {
    setState(() {
      customControllers[index].dispose();
      customControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Color(0xFF08959D), // Set the text color here
          ),
        ),
        backgroundColor: const Color(0xFF040326),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF08959D), // Set the back button color here
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Which Area To Explore?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8, // Space between bubbles horizontally
                  runSpacing: 8, // Space between bubbles vertically
                  children: [
                    ...options.map((option) {
                      final isSelected = selectedOptions.contains(option);
                      return ChoiceChip(
                        label: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF040326),
                        backgroundColor: Colors.grey[200],
                        checkmarkColor: Colors.teal,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedOptions.add(option);
                            } else {
                              selectedOptions.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                    // Custom Bubble
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showCustomInput = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'CUSTOM',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Show Text Field for Custom Input
            if (showCustomInput)
              Column(
                children: List.generate(
                  1,
                  (index) => Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: TextField(
                            controller: customControllers[index],
                            onChanged: (value) {
                              customControllers[index].value =
                                  TextEditingValue(text: value);
                            },
                            maxLines: 1,
                            decoration: const InputDecoration(
                                labelText: 'Enter custom option',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 6)),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width:
                              12), // Use width instead of height for horizontal spacing
                      ElevatedButton(
                        onPressed: () {
                          if (customControllers[index].text.isNotEmpty) {
                            setState(() {
                              options.add(customControllers[index].text);
                              selectedOptions
                                  .add(customControllers[index].text);
                              showCustomInput = false;
                              customControllers[index]
                                  .clear(); // Clear input instead of assigning ""
                            });
                          }
                        },
                        child: const Text('Add Custom Option'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 5),
            // Second Section: Opportunity Type with Toggle Switch
            const Text(
              'What Opportunity Type?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: opportunityTypes.keys.map((opportunity) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      opportunity,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Switch(
                      value: opportunityTypes[opportunity]!,
                      activeColor: Colors.teal, // Teal for toggle switch
                      onChanged: (value) {
                        setState(() {
                          opportunityTypes[opportunity] = value;
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            // Location Selector Section
            const Text(
              'Select Location Type:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLocationToggle("City"),
                _buildLocationToggle("State"),
                _buildLocationToggle("Country"),
              ],
            ),
            const SizedBox(height: 20),
            if (selectedLocationOption == "City")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Distance (in kms):",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: locationDistance,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: Colors.teal,
                    inactiveColor: Colors.grey,
                    label: '${locationDistance.toInt()} km',
                    onChanged: (value) {
                      setState(() {
                        locationDistance = value;
                      });
                    },
                  ),
                  Text('${locationDistance.toInt()} km'),
                ],
              ),
            if (selectedLocationOption == "State")
              DropdownButton<String>(
                value: selectedState.isEmpty ? null : selectedState,
                items: states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                hint: const Text("Choose a state"),
                onChanged: (value) {
                  setState(() {
                    selectedState = value!;
                  });
                },
              ),
            if (selectedLocationOption == "Country")
              TextField(
                onChanged: (value) {
                  setState(() {
                    enteredCountry = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type country name",
                ),
              ),
            const HeightSpacer(size: 20),
            CustomButton(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                var userId = prefs.getString('userId');

                final customInput = customControllers
                    .map((controller) => controller.text)
                    .toList();

                final filterData = CreateFilterRequest(
                  agentId: userId ?? '',
                  selectedOptions: selectedOptions,
                  opportunityTypes: opportunityTypes,
                  selectedLocationOption: selectedLocationOption,
                  locationDistance: locationDistance,
                  selectedState: selectedState,
                  enteredCountry: enteredCountry,
                  customOptions: customInput,
                );

                if (!context.mounted) return;

                final filterNotifier =
                    Provider.of<FilterNotifier>(context, listen: false);

                await filterNotifier.createFilter(userId!, filterData);

                if (!context.mounted) return;

                /// Safe navigation check before popping
              },
              text: 'Add Filters',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationToggle(String option) {
    return Row(
      children: [
        Text(option, style: const TextStyle(fontSize: 16)),
        Switch(
          value: selectedLocationOption == option,
          activeColor: Colors.teal,
          onChanged: (value) {
            setState(() {
              selectedLocationOption = value ? option : "";
            });
          },
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:jobhub_v1/views/common/height_spacer.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({Key? key}) : super(key: key);

//   @override
//   _FilterPageState createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   final List<String> options = [
//     'Web Development',
//     'App Development',
//     'Graphic Designer',
//     'Finance',
//     'Consulting',
//     'Marketing',
//     'Competitive Programming',
//     'Cyber Security',
//     'Blockchain',
//     'Research',
//     'UI/UX',
//     'Animator',
//   ];
//   final Map<String, bool> opportunityTypes = {
//     'Internship': false,
//     'Research': false,
//     'Freelance': false,
//     'Competition': false,
//   };
//   final List<String> states = [
//     "California",
//     "Texas",
//     "Florida",
//     "New York",
//     "Illinois",
//     "Pennsylvania",
//     "Ohio",
//     "Georgia",
//     "North Carolina",
//     "Michigan"
//   ];
//   final List<String> selectedOptions = [];
//   bool showCustomInput = false;
//   String customInputValue = "";
//   double selectedDistance = 10.0;
//   String selectedLocationOption = "";
//   double locationDistance = 10.0;
//   String selectedState = "";
//   String enteredCountry = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Filters',
//           style: TextStyle(
//             color: Color(0xFF08959D),
//           ),
//         ),
//         backgroundColor: const Color(0xFF040326),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color(0xFF08959D),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Which Area To Explore?',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               // Exclude ScrollBar for this Wrap section
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   ...options.map((option) {
//                     final isSelected = selectedOptions.contains(option);
//                     return ChoiceChip(
//                       label: Text(
//                         option,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : Colors.black,
//                         ),
//                       ),
//                       selected: isSelected,
//                       selectedColor: const Color(0xFF040326),
//                       backgroundColor: Colors.grey[200],
//                       checkmarkColor: Colors.teal,
//                       onSelected: (selected) {
//                         setState(() {
//                           if (selected) {
//                             selectedOptions.add(option);
//                           } else {
//                             selectedOptions.remove(option);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         showCustomInput = true;
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.teal,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'CUSTOM',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               if (showCustomInput)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     TextField(
//                       onChanged: (value) {
//                         customInputValue = value;
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Enter custom option',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (customInputValue.isNotEmpty) {
//                           setState(() {
//                             options.add(customInputValue);
//                             selectedOptions.add(customInputValue);
//                             showCustomInput = false;
//                             customInputValue = "";
//                           });
//                         }
//                       },
//                       child: const Text('Add Custom Option'),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 5),
//               const Text(
//                 'What Opportunity Type?',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Column(
//                 children: opportunityTypes.keys.map((opportunity) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         opportunity,
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                       Switch(
//                         value: opportunityTypes[opportunity]!,
//                         activeColor: Colors.teal,
//                         onChanged: (value) {
//                           setState(() {
//                             opportunityTypes[opportunity] = value;
//                           });
//                         },
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Select Location Type:',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildLocationToggle("City"),
//                   _buildLocationToggle("State"),
//                   _buildLocationToggle("Country"),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               if (selectedLocationOption == "City")
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Distance (in kms):",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Slider(
//                       value: locationDistance,
//                       min: 0,
//                       max: 100,
//                       divisions: 20,
//                       activeColor: Colors.teal,
//                       inactiveColor: Colors.grey,
//                       label: '${locationDistance.toInt()} km',
//                       onChanged: (value) {
//                         setState(() {
//                           locationDistance = value;
//                         });
//                       },
//                     ),
//                     Text('${locationDistance.toInt()} km'),
//                   ],
//                 ),
//               if (selectedLocationOption == "State")
//                 DropdownButton<String>(
//                   value: selectedState.isEmpty ? null : selectedState,
//                   items: states.map((state) {
//                     return DropdownMenuItem(
//                       value: state,
//                       child: Text(state),
//                     );
//                   }).toList(),
//                   hint: const Text("Choose a state"),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedState = value!;
//                     });
//                   },
//                 ),
//               if (selectedLocationOption == "Country")
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       enteredCountry = value;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: "Type country name",
//                   ),
//                 ),
//               const HeightSpacer(size: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//       ),
//     );
//   }

//   Widget _buildLocationToggle(String option) {
//     return Row(
//       children: [
//         Text(option, style: const TextStyle(fontSize: 16)),
//         Switch(
//           value: selectedLocationOption == option,
//           activeColor: Colors.teal,
//           onChanged: (value) {
//             setState(() {
//               selectedLocationOption = value ? option : "";
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
