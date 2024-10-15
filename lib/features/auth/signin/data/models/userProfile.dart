import 'package:qenan/features/home/data/models/attachments.dart';

class UserProfile {
  final String id;
  final String first_name;
  final String last_name;
  final String username;
  final String email;
  final String phone;
  final String dob;
  final String sex;
  final Attachment attachments;
  UserProfile(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.username,
      required this.email,
      required this.phone,
      required this.dob,
      required this.sex,
      required this.attachments});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      first_name: json['first_name']?.toString() ?? '',
      last_name: json['last_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      sex: json['sex']?.toString() ?? '',
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
    );
  }
}
