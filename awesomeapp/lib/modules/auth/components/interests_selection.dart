import 'package:flutter/material.dart';

import '../../../core/shared/custom_elevated_button.dart';

class InterestSelection extends StatefulWidget {
  final List<String> initialInterests;

  InterestSelection({required this.initialInterests});

  @override
  _InterestSelectionState createState() => _InterestSelectionState();
}

class _InterestSelectionState extends State<InterestSelection> {
  final List<String> allInterests = [
    'AI',
    'Designing',
    'Devops',
    'Cyber Security',
    'Cloud Computing',
    'Big Data',
    'Software Development',
    'Blockchain',
    'Digital Marketing',
    'Database Management',
    'Business Intelligence',
    'Network Infrastructure'
  ];
  late List<String> selectedInterests;

  @override
  void initState() {
    super.initState();
    selectedInterests = List.from(widget.initialInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Select Interests',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allInterests.map((interest) {
                      final isSelected = selectedInterests.contains(interest);
                      return ChoiceChip(
                        label: Text(
                          interest,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Color(0xFF321B48),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedInterests.add(interest);
                            } else {
                              selectedInterests.remove(interest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    manualAction: true,
                    onPressed: () {
                      Navigator.pop(context, selectedInterests);
                    },
                    text: 'Submit',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
