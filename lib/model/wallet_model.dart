// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

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
      print(wallet);
    } else {
      // Handle the case where userDetailsData is not a Map (e.g., it's a List).
      // You might want to log an error or handle this case differently based on your requirements.
      print('userDetailsData is not a Map: $walletData');
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

// List<Wallet> walletModelFromJson(String? str) {
//   if (str == null) {
//     throw const FormatException('Input string is null');
//   }

//   final decoded = json.decode(str);

//   if (decoded is List) {
//     return List<Wallet>.from(
//         decoded.map((x) => Wallet.fromJson(x)));
//   } else if (decoded is Map<String, dynamic>) {
//     // Adjust this part based on your actual JSON structure
//     // If it's a map, you might want to handle it differently
//     return [Wallet.fromJson(decoded)];
//   } else {
//     throw const FormatException('Invalid JSON format');
//   }
// }

// String walletModelToJson(List<Wallet> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wallet {
  final String id;
  final String pin;
  // Account account;
  final bool isPinSet;
  final dynamic mainBalance;
  final int availableBalance;
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
