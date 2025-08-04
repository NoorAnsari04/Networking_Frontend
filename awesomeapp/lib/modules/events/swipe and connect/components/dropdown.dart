class DropdownOptions {
  final String id;
  final String name;

  DropdownOptions({required this.id, required this.name});

  factory DropdownOptions.fromJson(Map<String, dynamic> json) {
    return DropdownOptions(
      id: json['_id'],   // or 'id' depending on your backend
      name: json['name'],
    );
  }
}
