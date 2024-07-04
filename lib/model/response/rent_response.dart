
import '../spacerent_model.dart';

class SpaceRentResponse {
  String? msg;
  List<SpaceRent> rent;

  SpaceRentResponse({required this.msg, required this.rent});

  factory SpaceRentResponse.fromJson(Map<String, dynamic> json) {
    // Check if 'rent' exists and is a list
    if (json.containsKey('rent') && json['rent'] is List) {
      var rentInfo = json['rent'] as List<dynamic>;
      List<SpaceRent> details =
          rentInfo.map((rentJson) => SpaceRent.fromJson(rentJson)).toList();
      return SpaceRentResponse(
        msg: json['msg'] as String,
        rent: details,
      );
    } else {
      // If 'rentInfos' is not a list, handle it accordingly
      // For example, you can create a single rent object
      SpaceRent rentInfo = SpaceRent.fromJson(json['rent']);
      return SpaceRentResponse(
        msg: json['msg'] as String,
        rent: [rentInfo],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'rent': rent.map((rent) => rent.toJson()).toList(),
    };
  }
}
