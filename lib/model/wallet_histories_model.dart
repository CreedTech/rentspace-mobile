class WalletHistoriesModel {
  WalletHistoriesModel({
    required this.walletHistories,
  });
  List<WalletHistories>? walletHistories;

  WalletHistoriesModel.fromJson(Map<String, dynamic> json) {
    final dynamic walletHistoriesData = json['walletHistories'];
    if (walletHistoriesData is List<dynamic>) {
      // If walletHistoriesData is a List, map each element to WalletHistories object.
      walletHistories =
          walletHistoriesData.map((e) => WalletHistories.fromJson(e)).toList();
    } else if (walletHistoriesData is Map<String, dynamic>) {
      // If walletHistoriesData is a Map, create a single WalletHistories object.
      walletHistories = [WalletHistories.fromJson(walletHistoriesData)];
    } else {
      // Handle other cases if necessary.
      walletHistories = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['walletHistories'] = walletHistories!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class WalletHistories {
  final String id;
  final String transactionType;
  final dynamic amount;
  final String transactionReference;
  final String merchantReference;
  final String description;
  final String message;
  final String fees;
  final String totalAmount;
  final String status;

  final String activityDate;

  WalletHistories({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.transactionReference,
    required this.merchantReference,
    required this.description,
    required this.message,
    required this.fees,
    required this.totalAmount,
    required this.status,
    required this.activityDate,
  });

  factory WalletHistories.fromJson(Map<String, dynamic> json) =>
      WalletHistories(
        id: json["_id"],
        transactionType: json["transactionType"],
        amount: json["amount"],
        transactionReference: json["transactionReference"],
        merchantReference: json["merchantReference"],
        description: json["description"],
        message: json["message"],
        fees: json["fees"],
        totalAmount: json["totalAmount"],
        status: json["status"],
        activityDate: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "transactionType": transactionType,
        "amount": amount,
        "transactionReference": transactionReference,
        "merchantReference": merchantReference,
        "description": description,
        "message": message,
        "fees": fees,
        "totalAmount": totalAmount,
        "status": status,
        "createdAt": activityDate,
      };
}
