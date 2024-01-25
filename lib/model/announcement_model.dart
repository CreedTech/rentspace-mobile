import 'dart:convert';

class AnnouncementModel {
  int id;
  String body;
  DateTime date;

  AnnouncementModel({
    required this.id,
    required this.body,
    required this.date,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'date': date,
      // Exclude 'imageUrl' from the map
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'],
      body: map['body'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AnnouncementModel.fromJson(String source) =>
      AnnouncementModel.fromMap(json.decode(source));
}
