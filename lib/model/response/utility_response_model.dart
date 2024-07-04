class UtilityResponseModel {
  UtilityResponseModel({
    required this.utilities,
  });
  List<UtilityResponse>? utilities;

  UtilityResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic utilitiesData = json['data'];
    if (utilitiesData is List<dynamic>) {
      utilities =
          utilitiesData.map((e) => UtilityResponse.fromJson(e)).toList();
    } else if (utilitiesData is Map<String, dynamic>) {
      utilities = [UtilityResponse.fromJson(utilitiesData)];
    } else {
      utilities = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = utilities!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class UtilityResponse {
  final String id;
  final String name;
  final dynamic division;
  final String product;
  final String category;

  UtilityResponse({
    required this.id,
    required this.name,
    required this.division,
    required this.product,
    required this.category,
  });

  factory UtilityResponse.fromJson(Map<String, dynamic> json) =>
      UtilityResponse(
        id: json['id'],
        name: json['name'],
        division: json['division'],
        product: json['product'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'division': division,
        'product': product,
        'category': category,
      };
}
