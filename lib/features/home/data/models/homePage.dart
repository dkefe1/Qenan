import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/data/models/category.dart';
import 'package:qenan/features/home/data/models/sections.dart';

class HomePage {
  final List<Sections> popular;
  final List<Sections> for_you;
  final List<Sections> creative;
  final List<Bundles> bundles;
  final List<Category> categories;

  HomePage({
    required this.popular,
    required this.for_you,
    required this.creative,
    required this.bundles,
    required this.categories,
  });

  factory HomePage.fromJson(Map<String, dynamic> json) {
    return HomePage(
        popular: (json['popular'] as List<dynamic>?)?.map((item) {
              return Sections.fromJson(item);
            }).toList() ??
            [],
        for_you: (json['for_you'] as List<dynamic>?)?.map((item) {
              return Sections.fromJson(item);
            }).toList() ??
            [],
        creative: (json['creative'] as List<dynamic>?)?.map((item) {
              return Sections.fromJson(item);
            }).toList() ??
            [],
        bundles: (json['bundles'] as List<dynamic>?)?.map((item) {
              return Bundles.fromJson(item);
            }).toList() ??
            [],
        categories: (json['categories'] as List<dynamic>?)
                ?.map((item) => Category.fromJson(item))
                .toList() ??
            []);
  }
}
