// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

List<WalletModel> walletModelFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded is List) {
    return List<WalletModel>.from(decoded.map((x) => WalletModel.fromJson(x)));
  } else if (decoded is Map<String, dynamic>) {
    // Adjust this part based on your actual JSON structure
    // If it's a map, you might want to handle it differently
    return [WalletModel.fromJson(decoded)];
  } else {
    throw const FormatException('Invalid JSON format');
  }
}

String walletModelToJson(List<WalletModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalletModel {
  Wallet wallet;

  WalletModel({
    required this.wallet,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        wallet: Wallet.fromJson(json["wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "wallet": wallet.toJson(),
      };
}

class Wallet {
  String id;
  // String user;
  // Account account;
  bool isPinSet;
  int mainBalance;
  int availableBalance;
  String walletId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Wallet({
    required this.id,
    // required this.user,
    // required this.account,
    required this.isPinSet,
    required this.mainBalance,
    required this.availableBalance,
    required this.walletId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["_id"],
        // user: json["user"],
        // account: Account.fromJson(json["account"]),
        isPinSet: json["isPinSet"],
        mainBalance: json["mainBalance"],
        availableBalance: json["availableBalance"],
        walletId: json["walletId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        // "user": user,
        // "account": account.toJson(),
        "isPinSet": isPinSet,
        "mainBalance": mainBalance,
        "availableBalance": availableBalance,
        "walletId": walletId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Account {
  String id;
  String user;
  String accountReference;
  String accountName;
  String currencyCode;
  String customerEmail;
  String customerName;
  String walletId;
  String bankName;
  String bankCode;
  String collectionChannel;
  String reservationReference;
  String reservedAccountType;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Account({
    required this.id,
    required this.user,
    required this.accountReference,
    required this.accountName,
    required this.currencyCode,
    required this.customerEmail,
    required this.customerName,
    required this.walletId,
    required this.bankName,
    required this.bankCode,
    required this.collectionChannel,
    required this.reservationReference,
    required this.reservedAccountType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["_id"],
        user: json["user"],
        accountReference: json["accountReference"],
        accountName: json["accountName"],
        currencyCode: json["currencyCode"],
        customerEmail: json["customerEmail"],
        customerName: json["customerName"],
        walletId: json["walletId"],
        bankName: json["bankName"],
        bankCode: json["bankCode"],
        collectionChannel: json["collectionChannel"],
        reservationReference: json["reservationReference"],
        reservedAccountType: json["reservedAccountType"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "accountReference": accountReference,
        "accountName": accountName,
        "currencyCode": currencyCode,
        "customerEmail": customerEmail,
        "customerName": customerName,
        "walletId": walletId,
        "bankName": bankName,
        "bankCode": bankCode,
        "collectionChannel": collectionChannel,
        "reservationReference": reservationReference,
        "reservedAccountType": reservedAccountType,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
