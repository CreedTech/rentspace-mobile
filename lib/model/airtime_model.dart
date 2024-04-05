
class AirtimesModel {
  AirtimesModel({
    required this.airtimes,
  });
  List<Airtimes>? airtimes;

  AirtimesModel.fromJson(Map<String, dynamic> json) {
    final dynamic airtimesData = json['data'];
    if (airtimesData is List<dynamic>) {
      // If airtimesData is a List, map each element to Airtimes object.
      airtimes = airtimesData.map((e) => Airtimes.fromJson(e)).toList();
      // print(airtimes!.length);
      // print(airtimesData[0]);
    } else if (airtimesData is Map<String, dynamic>) {
      // If airtimesData is a Map, create a single Airtimes object.
      airtimes = [Airtimes.fromJson(airtimesData)];
    } else {
      // Handle other cases if necessary.
      // print('Invalid airtimes data: $airtimesData');
      airtimes = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = airtimes!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Airtimes {
  final String id;
  final int phoneNumber;
  final int amount;
  final String? biller;
  final String status;
  final String createdAt;

  Airtimes({
    required this.id,
    required this.phoneNumber,
    required this.amount,
    required this.biller,
    required this.status,
    required this.createdAt,
  });

  factory Airtimes.fromJson(Map<String, dynamic> json) => Airtimes(
        id: json["_id"],
        phoneNumber: json["phoneNumber"],
        amount: json["amount"],
        status: json["status"],
        biller: json["biller"] ?? 'Bill Payment',
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phoneNumber": phoneNumber,
        "amount": amount,
        "status": status,
        "biller": biller ?? 'Bill Payment',
        "createdAt": createdAt,
      };
}
