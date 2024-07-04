class WithdrawalAccountModel {
  WithdrawalAccountModel({
    required this.withdrawalAccount,
  });
  List<WithdrawalAccount>? withdrawalAccount;

  WithdrawalAccountModel.fromJson(Map<String, dynamic> json) {
    final dynamic withdrawalAccountData = json['withdrawalAccount'] ?? '';
    if (withdrawalAccountData is Map<String, dynamic>) {
      // If userDetailsData is a Map, create a single UserDetailsModel object.
      withdrawalAccount = [WithdrawalAccount.fromJson(withdrawalAccountData)];
    } else {
      withdrawalAccount = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['withdrawalAccount'] =
        withdrawalAccount!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class WithdrawalAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String bankCode;
  final String user;
  final String createdAt;
  final String updatedAt;

  WithdrawalAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.bankCode,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WithdrawalAccount.fromJson(Map<String, dynamic> json) =>
      WithdrawalAccount(
        id: json["_id"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        accountHolderName: json["accountHolderName"],
        bankCode: json["bankCode"],
        user: json["user"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "accountHolderName": accountHolderName,
        "bankCode": bankCode,
        "user": user,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
