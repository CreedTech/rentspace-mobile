import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String userFirst;
  final String userLast;
  final String userWalletBalance;
  final String userWalletNumber;
  final String userStatus;
  final String userPhone;
  final String userId;
  final String kyc;
  final String accountDate;
  final String accountName;
  final String accountNumber;
  final String dvaName;
  final String dvaNumber;
  final String dvaUsername;
  final String dvaDate;
  final String address;
  final String bankName;
  final String bvn;
  final String hasDva;
  final String hasVerifiedBvn;
  final String hasVerifiedKyc;
  final String hasVerifiedMail;
  final String hasVerifiedPhone;
  final String cardCVV;
  final String cardDigit;
  final String cardExpire;
  final String cardHolder;
  final String email;
  String? gender;
  String? date_of_birth;
  final String referalCode;
  final String referalId;
  late final int referals;
  final String utilityPoints;
  final String rentspaceID;
  final String status;
  final String transactionPIN;
  final String image;
  final String Idimage;
  final String finance_health;
  final String userPassword;
  final List activities;

  User({
    required this.id,
    required this.userFirst,
    required this.userLast,
    required this.userWalletBalance,
    required this.userWalletNumber,
    required this.userStatus,
    required this.userPhone,
    required this.userId,
    required this.kyc,
    required this.accountDate,
    required this.accountName,
    required this.accountNumber,
    required this.address,
    required this.bankName,
    required this.dvaName,
    required this.dvaNumber,
    required this.dvaUsername,
    required this.dvaDate,
    required this.bvn,
    required this.hasDva,
    required this.hasVerifiedBvn,
    required this.hasVerifiedKyc,
    required this.hasVerifiedMail,
    required this.hasVerifiedPhone,
    required this.cardCVV,
    required this.cardDigit,
    required this.cardExpire,
    required this.cardHolder,
    required this.email,
    this.gender,
    this.date_of_birth,
    required this.referalCode,
    required this.referalId,
    required this.referals,
    required this.utilityPoints,
    required this.rentspaceID,
    required this.status,
    required this.transactionPIN,
    required this.image,
    required this.Idimage,
    required this.finance_health,
    required this.userPassword,
    required this.activities,
  });

  static User fromSnapshot(DocumentSnapshot data) {
    User user = User(
      userFirst: data['firstname'],
      id: data['id'],
      userLast: data['lastname'],
      userWalletBalance: data['wallet_balance'],
      userWalletNumber: data['wallet_id'],
      userStatus: data['status'],
      userPhone: data['phone'],
      userId: data['rentspace_id'],
      kyc: data['kyc_details'],
      accountDate: data['account_date'],
      accountName: data['account_name'],
      accountNumber: data['account_number'],
      dvaName: data['dva_name'],
      dvaNumber: data['dva_number'],
      dvaDate: data['dva_date'],
      dvaUsername: data['dva_username'],
      address: data['address'],
      bankName: data['bank_name'],
      bvn: data['bvn'],
      hasVerifiedBvn: data['has_verified_bvn'],
      hasDva: data['has_dva'],
      hasVerifiedKyc: data['has_verified_kyc'],
      hasVerifiedMail: data['has_verified_email'],
      hasVerifiedPhone: data['has_verified_phone'],
      cardCVV: data['card_cvv'],
      cardDigit: data['card_digit'],
      cardExpire: data['card_expire'],
      cardHolder: data['card_holder'],
      email: data['email'],
      gender: data['gender'] ?? '',
      date_of_birth: data['date_of_birth'] ?? '',
      referalCode: data['referal_code'],
      referalId: data['referar_id'],
      referals: data['referals'],
      utilityPoints: data['utility_points'],
      rentspaceID: data['rentspace_id'],
      status: data['status'],
      transactionPIN: data['transaction_pin'],
      image: data['image'],
      Idimage: data['id_card'],
      finance_health: data['finance_health'],
      userPassword: data['password'],
      activities: List.from(data['activities']).reversed.toList(),
    );
    return user;
  }
}
