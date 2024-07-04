class UtilityHistoryModel {
  UtilityHistoryModel({
    required this.utilityHistories,
  });
  List<UtilityHistory>? utilityHistories;

  UtilityHistoryModel.fromJson(Map<String, dynamic> json) {
    final dynamic utilityHistoriesData = json['utilityHistories'];
    if (utilityHistoriesData is List<dynamic>) {
      utilityHistories =
          utilityHistoriesData.map((e) => UtilityHistory.fromJson(e)).toList();
    } else if (utilityHistoriesData is Map<String, dynamic>) {

      utilityHistories = [UtilityHistory.fromJson(utilityHistoriesData)];
    } else {
      utilityHistories = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['utilityHistories'] =
        utilityHistories!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class UtilityHistory {
  final String id;
  final String transactionType;
  final dynamic amount;
  final String biller;
  final String transactionReference;
  final String merchantReference;
  final String description;
  final String status;
  final String fees;
  final String totalAmount;
  final String createdAt;
  final String updatedAt;

  UtilityHistory({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.biller,
    required this.transactionReference,
    required this.merchantReference,
    required this.description,
    required this.status,
    required this.fees,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UtilityHistory.fromJson(Map<String, dynamic> json) => UtilityHistory(
        id: json['_id'],
        transactionType: json['transactionType'],
        amount: json['amount'],
        biller: json['biller'],
        transactionReference: json['transactionReference'],
        description: json['description'],
        merchantReference: json['merchantReference'],
        status: json['status'],
        fees: json['fees'],
        totalAmount: json['totalAmount'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'transactionType': transactionType,
        'amount': amount,
        'biller': biller,
        'transactionReference': transactionReference,
        'description': description,
        'merchantReference': merchantReference,
        'status': status,
        'fees': fees,
        'totalAmount': totalAmount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
