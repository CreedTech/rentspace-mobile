class RecentTransfersModel {
  RecentTransfersModel({
    required this.recentTransfers,
  });
  List<RecentTransfers>? recentTransfers;

  RecentTransfersModel.fromJson(Map<String, dynamic> json) {
    final dynamic recentTransfersData = json['recentTransfers'];
    print('recentTransfersData');
    // print(recentTransfersData);
    if (recentTransfersData is List<dynamic>) {
      recentTransfers =
          recentTransfersData.map((e) => RecentTransfers.fromJson(e)).toList();
      print('rents length');
      // print(rents!.length);
    } else if (recentTransfersData is Map<String, dynamic>) {
      print("Here");

      recentTransfers = [RecentTransfers.fromJson(recentTransfersData)];
      print("recentTransfers");
      // print(rents);
    } else {
      // print('Invalid activities data: $recentTransfersData');
      recentTransfers = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['recentTransfers'] = recentTransfers!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class RecentTransfers {
  final String id;
  final String accountNumber;
  final String bankCode;

  RecentTransfers({
    required this.id,
    required this.accountNumber,
    required this.bankCode,
  });

  factory RecentTransfers.fromJson(Map<String, dynamic> json) =>
      RecentTransfers(
        id: json['_id'],
        accountNumber: json['accountNumber'],
        bankCode: json['bankCode'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'accountNumber': accountNumber,
        'bankCode': bankCode,
      };
}
