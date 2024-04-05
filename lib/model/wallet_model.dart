
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
      // print(wallet);
    } else {
      // Handle the case where userDetailsData is not a Map (e.g., it's a List).
      // You might want to log an error or handle this case differently based on your requirements.
      // print('userDetailsData is not a Map: $walletData');
      // Set userDetails to an empty list or null, depending on your needs.
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
  // Account account;
  final bool isPinSet;
  final dynamic mainBalance;
  final num availableBalance;
  final String walletId;
  final String createdAt;
  final String updatedAt;

  Wallet({
    required this.id,
    required this.pin,
    // required this.account,
    required this.isPinSet,
    required this.mainBalance,
    required this.availableBalance,
    required this.walletId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["_id"],
        pin: json["pin"],
        // account: Account.fromJson(json["account"]),
        isPinSet: json["isPinSet"],
        mainBalance: json["mainBalance"],
        availableBalance: json["availableBalance"],
        walletId: json["walletId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "pin": pin,
        // "account": account.tsoJson(),
        "isPinSet": isPinSet,
        "mainBalance": mainBalance,
        "availableBalance": availableBalance,
        "walletId": walletId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
