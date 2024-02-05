// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  final String id;
  final String email;
  final String userName;
  final String firstName;
  final String residentialAddress;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String gender;
  final String referralCode;
  final String dateOfBirth;
  final String otp;
  final int otpExpireIn;
  final bool verified;
  final String role;
  final bool active;
  final bool hasBvn;
  final bool hasRent;
  final bool hasVerifiedBvn;
  final bool hasVerifiedEmail;
  final bool hasVerifiedKyc;
  final bool hasVerifiedPhone;
  final int loanAmount;
  final int financeHealth;
  final String status;
  final int totalAssets;
  final int totalInterests;
  final int totalDebts;
  final int totalProfits;
  final int totalSavings;
  final String date;
  final String createdAt;
  final String updatedAt;

  UserDetailsModel({
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
    required this.otp,
    required this.otpExpireIn,
    required this.verified,
    required this.role,
    required this.active,
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
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
        id: json["_id"],
        email: json["email"],
        userName: json["userName"],
        firstName: json["firstName"],
        residentialAddress: json["residential_address"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        gender: json["gender"],
        referralCode: json["referral_code"],
        dateOfBirth: json["date_of_birth"],
        otp: json["otp"],
        otpExpireIn: json["otpExpireIn"],
        verified: json["verified"],
        role: json["role"],
        active: json["active"],
        hasBvn: json["has_bvn"],
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
        "otp": otp,
        "otpExpireIn": otpExpireIn,
        "verified": verified,
        "role": role,
        "active": active,
        "has_bvn": hasBvn,
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
      };
}
