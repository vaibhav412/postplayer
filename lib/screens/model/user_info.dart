class UserInfo {
  UserInfo({this.phoneNumber, this.firstName, this.lastName});

  final String firstName;
  final String lastName;
  final int phoneNumber;

  Map<String, dynamic> toMap() {
    return {
      'First Name': firstName,
      'Last Name': lastName,
      'Phone Number': phoneNumber,
    };
  }
}
