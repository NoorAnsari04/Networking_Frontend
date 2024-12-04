import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/shared/custom_elevated_button.dart';
import '../../../../core/constants/icon_constants.dart';
import '../../../../core/shared/custum_appbar.dart';
import '../../../auth/components/user_type_selection.dart';

class PreferencesScreen extends StatefulWidget {
  static const id = 'preferences';

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool isStudent = true;
  String? selectedProfession;
  String? selectedIndustry;
  TextEditingController reasonController = TextEditingController();

  List<String> professions = [
    'Flutter Developer',
    'ReactJs Developer',
    'UX/UI Designer',
    'Data Analyst',
    'Mern Stack Developer',
    'Mobile App Developer',
    'Website Developer',
    'SEO Specialist',
    'Digital Marketer',
    'Network Engineer',
    'DevOps Engineer',
    'Project Manager',
    'Business Analyst',
    'Data Scientist'
  ];

  List<String> industries = [
    'AI',
    'Design',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              SafeArea(
                child: CustomAppBar(
                  title: 'Preferences',
                  iconPath: IconConstants.backward_arrow,
                ),
              ),
              SizedBox(height: 40.h),
              UserTypeSelection(
                isStudent: isStudent,
                onChanged: (value) {
                  setState(() {
                    isStudent = value!;
                  });
                },
                title: 'Whom do you want to connect with?',
              ),
              SizedBox(height: 20.h),
              if (!isStudent) ...[
                Text('Profession:', style: TextStyle(fontSize: 16.sp)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: selectedProfession,
                    isExpanded: true,
                    items: professions.map((String profession) {
                      return DropdownMenuItem<String>(
                        value: profession,
                        child: Text(profession),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProfession = newValue;
                      });
                    },
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              Text('Industry:', style: TextStyle(fontSize: 16.sp)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: selectedIndustry,
                  isExpanded: true,
                  items: industries.map((String industry) {
                    return DropdownMenuItem<String>(
                      value: industry,
                      child: Text(industry),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIndustry = newValue;
                    });
                  },
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomElevatedButton(
                  onPressed: () {},
                  text: 'Submit',
                  manualAction: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
