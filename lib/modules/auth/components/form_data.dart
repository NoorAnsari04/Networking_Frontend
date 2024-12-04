import 'package:flutter/material.dart';

class FormData {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController degreeProgramController = TextEditingController();
  final TextEditingController linkedinUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> interests = [];
  String? selectedYear;
  String? selectedInstitute;

  final List<String> years = ['2027', '2026', '2025', '2024'];
  final List<String> institutes = [
    'Karachi University',
    'Lahore University',
    'Islamabad University'
  ];
}
