class UserProfileManager {
  String? name;
  String? lastName;
  String? email;
  String? imageUrl;
  String? company;
  String? position;
  String? sessionsDeliver;
  String? description;

  bool isLoading = true;

  String getInitials(String? firstName, String? lastName) {
    if (firstName == null || lastName == null) return '';
    return firstName[0] + lastName[0];
  }
}
