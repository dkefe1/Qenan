class Socials {
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? tiktok;
  final String? linkedin;
  Socials(
      {this.facebook,
      this.twitter,
      this.instagram,
      this.tiktok,
      this.linkedin});
  factory Socials.fromJson(Map<String, dynamic> json) {
    return Socials(
      facebook: json['facebook']?.toString() ?? '',
      twitter: json['twitter']?.toString() ?? '',
      instagram: json['instagram']?.toString() ?? '',
      tiktok: json['tiktok']?.toString() ?? '',
      linkedin: json['linkedin']?.toString() ?? '',
    );
  }
}
