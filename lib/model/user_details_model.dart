
import 'wallet_model.dart';

class UserModel {
  UserModel({
    required this.userDetails,
  });
  List<UserDetailsModel>? userDetails;

// UserModel.fromJson(Map<String, dynamic> json) {
  UserModel.fromJson(Map<String, dynamic> json) {
    final dynamic userDetailsData = json['userDetails'];
    if (userDetailsData is Map<String, dynamic>) {
      // If userDetailsData is a Map, create a single UserDetailsModel object.
      userDetails = [UserDetailsModel.fromJson(userDetailsData)];
      // print(userDetails);
    } else {
      // Handle the case where userDetailsData is not a Map (e.g., it's a List).
      // You might want to log an error or handle this case differently based on your requirements.
      // print('userDetailsData is not a Map: $userDetailsData');
      // Set userDetails to an empty list or null, depending on your needs.
      userDetails = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userDetails'] = userDetails!.map((e) => e.toJson()).toList();
    return _data;
  }
}


class UserDetailsModel {
  final String id;
  final String email;
  final String userName;
  final String firstName;
  final String residentialAddress;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final String password;
  final String referralCode;
  final String dateOfBirth;
  final bool verified;
  final String role;
  final bool active;
  final bool hasDva;
  final String bvn;
  final String kyc;
  final bool hasBvn;
  final bool isPinSet;
  final bool hasRent;
  final bool hasVerifiedBvn;
  final bool hasVerifiedEmail;
  final bool hasVerifiedKyc;
  final bool hasVerifiedPhone;
  final int loanAmount;
  // TODO  change to final string
  final String dvaName;
  final String dvaNumber;
  final String dvaUsername;
  //  final String Idimage;
  final int referrals;
  final num referralPoints;
  // TODO  change to number
  final num utilityPoints;
  final dynamic financeHealth;
  final String status;
  final dynamic totalAssets;
  final dynamic totalInterests;
  final dynamic totalDebts;
  final dynamic totalProfits;
  final dynamic totalSavings;
  // TODO  change to final string
  final String cardCVV;
  final String cardDigit;
  final String cardExpire;
  // TODO ADD TO BACKEND
  //  final bool cardHolder;
  final String date;
  final String createdAt;
  final String updatedAt;
  //  final String userWalletBalance;
  //  final String userWalletNumber;
  //  final String referrar_id; 
  //  final String otp;
  //  final int otpExpireIn;
  //  final String accountDate;
  //  final String accountName;
  //  final String accountNumber;
  //  final String referalId;
  // TODO  change to final string
  final String rentspaceID;
  final String avatar;
  final List<dynamic> activities;
  final List<dynamic> walletHistories;
  final List<dynamic> referredUsers;
  final Wallet wallet;

  UserDetailsModel({
    required this.kyc,
    // required this.Idimage,
    required this.dvaName,
    required this.dvaNumber,
    required this.dvaUsername,
    required this.referrals,
    required this.utilityPoints,
    required this.cardCVV,
    required this.cardDigit,
    required this.cardExpire,
    required this.isPinSet,
    // TODO ADD TO BACKEND
    // required this.cardHolder,
    required this.id,
    required this.email,
    required this.userName,
    required this.firstName,
    required this.residentialAddress,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.gender,
    required this.referralCode,
    required this.dateOfBirth,
    required this.verified,
    required this.role,
    required this.active,
    required this.hasDva,
    required this.bvn,
    required this.hasBvn,
    required this.hasRent,
    required this.hasVerifiedBvn,
    required this.hasVerifiedEmail,
    required this.hasVerifiedKyc,
    required this.hasVerifiedPhone,
    required this.loanAmount,
    required this.financeHealth,
    required this.status,
    required this.totalAssets,
    required this.totalInterests,
    required this.totalDebts,
    required this.totalProfits,
    required this.totalSavings,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    // required this.referrar_id,
    // required this.otp,
    // required this.otpExpireIn,
    required this.rentspaceID,
    required this.avatar,
    required this.referralPoints,
    // required this.userWalletBalance,
    // required this.userWalletNumber,
    // required this.accountDate,
    // required this.accountName,
    // required this.accountNumber,
    // required this.referalId,
    required this.wallet,
    required this.activities,
    required this.walletHistories,
    required this.referredUsers,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        avatar: json['avatar']['url'],
        id: json["_id"],
        email: json["email"],
        userName: json["userName"],
        firstName: json["firstName"],
        residentialAddress: json["residential_address"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        gender: json["gender"],
        referralPoints: json["referralPoints"],
        referralCode: json["referral_code"],
        dateOfBirth: json["date_of_birth"],
        verified: json["verified"],
        role: json["role"],
        isPinSet: json["isPinSet"],
        active: json["active"],
        bvn: json["bvn"],
        hasBvn: json["has_bvn"],
        hasDva: json["has_dva"],
        hasRent: json["has_rent"],
        hasVerifiedBvn: json["has_verified_bvn"],
        hasVerifiedEmail: json["has_verified_email"],
        hasVerifiedKyc: json["has_verified_kyc"],
        hasVerifiedPhone: json["has_verified_phone"],
        loanAmount: json["loan_amount"],
        financeHealth: json["finance_health"],
        status: json["status"],
        totalAssets: json["total_assets"],
        totalInterests: json["total_interests"],
        totalDebts: json["total_debts"],
        totalProfits: json["total_profits"],
        totalSavings: json["total_savings"],
        date: json["date"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        // TODO ADD TO BACKEND
        // cardHolder: json["card_holder"],
        dvaName: json["dva_name"],
        dvaNumber: json["dva_number"],
        dvaUsername: json["dva_username"],
        kyc: json["kyc"],
        referrals: json["referrals"],
        utilityPoints: json["utility_points"],
        cardCVV: json["card_cvv"],
        cardDigit: json["card_digit"],
        // Idimage: json["id_card"],
        cardExpire: json["card_expire"],
        // referrar_id: json["referrar_id"],
        // otp: json["otp"],
        // otpExpireIn: json["otpExpireIn"],
        // userWalletNumber: json['wallet_id'],
        // referalId: json["referal_id"],
        rentspaceID: json["rentspace_id"],
        // userWalletBalance: json['wallet_balance'] ?? '',
        // accountNumber: json["account_number"] ?? '',
        // accountName: json["account_name"] ?? '',
        // accountDate: json["account_date"] ?? '',
        // activities: Activities.fromJson(json["activities"]),
        wallet: Wallet.fromJson(json["wallet"]),
        activities: json["activities"],
        walletHistories: json["walletHistories"],
        referredUsers: json["referredUsers"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "userName": userName,
        "firstName": firstName,
        "residential_address": residentialAddress,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "password": password,
        "gender": gender,
        "referral_code": referralCode,
        "date_of_birth": dateOfBirth,
        "verified": verified,
        "role": role,
        "referralPoints": referralPoints,
        "isPinSet": isPinSet,
        "active": active,
        // "id_card": Idimage,
        "kyc": kyc,
        "bvn": bvn,
        "has_bvn": hasBvn,
        "has_dva": hasDva,
        "has_rent": hasRent,
        "has_verified_bvn": hasVerifiedBvn,
        "has_verified_email": hasVerifiedEmail,
        "has_verified_kyc": hasVerifiedKyc,
        "has_verified_phone": hasVerifiedPhone,
        "loan_amount": loanAmount,
        "finance_health": financeHealth,
        "status": status,
        "total_assets": totalAssets,
        "total_interests": totalInterests,
        "total_debts": totalDebts,
        "total_profits": totalProfits,
        "total_savings": totalSavings,
        "date": date,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "dva_name": dvaName,
        "dva_number": dvaNumber,
        "dva_username": dvaUsername,
        "referrals": referrals,
        "utility_points": utilityPoints,
        // "card_cvv": cardCVV,
        // "card_digit": cardDigit,
        // "card_expire": cardExpire,
        // "referal_id": referalId,
        // "otp": otp,
        "rentspace_id": rentspaceID,
        "avatar": avatar,
        // "wallet_balance": userWalletBalance,
        // "wallet_id": userWalletNumber,
        // "referrar_id": referrar_id,
        // "otpExpireIn": otpExpireIn,
        // "account_date": accountDate,
        // "account_name": accountName,
        // "card_holder": cardHolder,
        // "account_number": accountNumber,
        "activities": activities,
        "walletHistories": walletHistories,
        "referredUsers": referredUsers,
        "wallet": wallet.toJson(),
      };
}



