import 'package:shared_preferences/shared_preferences.dart';

class LocationModel {
  final String id;
  final String text;
  final String parentID;

  LocationModel({required this.id, required this.text, required this.parentID});

  static Future<String> _getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lan') ?? 'uz'; // Default to 'uz'
  }

  static Future<LocationModel> fromJson(Map<String, dynamic> json) async {
    final lang = await _getLanguage();
    String nameKey;
    switch (lang) {
      case 'en':
        nameKey = 'name_en';
        break;
      case 'ru':
        nameKey = 'name_ru';
        break;
      case 'uz':
      default:
        nameKey = 'name_uz';
    }
    final name = json[nameKey] ?? json['name'] ?? '';
    return LocationModel(
      id: json['id'].toString(),
      text: name,
      parentID: json['region_id']?.toString() ?? json['district_id']?.toString() ?? '0',
    );
  }
}
