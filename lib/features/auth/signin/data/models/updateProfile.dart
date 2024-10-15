import 'dart:io';

class UpdateProfile {
  final String first_name;
  final String last_name;
  final String email;
  final String dob;
  final String phone;
  final String sex;
  final File photo;
  UpdateProfile(
      {required this.first_name,
      required this.last_name,
      required this.email,
      required this.dob,
      required this.phone,
      required this.sex,
      required this.photo});
}
