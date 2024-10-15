class Bio {
  final List<String> profession;
  final List<String> industry;
  final String experience_since;
  Bio(
      {required this.profession,
      required this.industry,
      required this.experience_since});

  factory Bio.fromJson(Map<String, dynamic> json) {
    return Bio(
      profession: List<String>.from(json['profession']),
      industry: List<String>.from(json['industry']),
      experience_since: json['experience_since']?.toString() ?? '',
    );
  }
}
