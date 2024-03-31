
import 'dart:convert';

class UserModel {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String dateOfBirth;
  final String residentialAddress;
  final String gender;
  String? referralCode;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.dateOfBirth,
    required this.residentialAddress,
    required this.gender,
    this.referralCode,
  });



  Map<String, dynamic> toMap() {
    return {
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
      // Exclude 'imageUrl' from the map
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      userName: map['userName'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      gender: map['gender'],
      residentialAddress: map['residential_address'],
      referralCode: map['referral_code'],
      dateOfBirth: map['date_of_birth'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
