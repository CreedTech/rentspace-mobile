class WalletModel {
  WalletModel({
    required this.wallet,
  });
  List<Wallet>? wallet;

  WalletModel.fromJson(Map<String, dynamic> json) {
    final dynamic walletData = json['wallet'];
    if (walletData is Map<String, dynamic>) {
      // If userDetailsData is a Map, create a single UserDetailsModel object.
      wallet = [Wallet.fromJson(walletData)];
    } else {
      // You might want to log an error or handle this case differently based on your requirements.
      wallet = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['wallet'] = wallet!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Wallet {
  final String id;
  final String pin;
  final bool isPinSet;
  final dynamic mainBalance;
  final num availableBalance;
  final String walletId;
  final String createdAt;
  final String updatedAt;
  final String? lastWithdrawalDate;
  final String? nextWithdrawalDate;

  Wallet({
    required this.id,
    required this.pin,
    required this.isPinSet,
    required this.mainBalance,
    required this.availableBalance,
    required this.walletId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastWithdrawalDate,
    required this.nextWithdrawalDate,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["_id"],
        pin: json["pin"],
        isPinSet: json["isPinSet"],
        mainBalance: json["mainBalance"],
        availableBalance: json["availableBalance"],
        walletId: json["walletId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        lastWithdrawalDate: json["lastWithdrawalDate"] ?? '',
        nextWithdrawalDate: json["nextWithdrawalDate"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "pin": pin,
        "isPinSet": isPinSet,
        "mainBalance": mainBalance,
        "availableBalance": availableBalance,
        "walletId": walletId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "lastWithdrawalDate": lastWithdrawalDate,
        "nextWithdrawalDate": nextWithdrawalDate,
      };
}
