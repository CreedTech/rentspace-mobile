import 'dart:convert';

class SpaceRentModel {
  SpaceRentModel({
    required this.rents,
  });
  List<SpaceRent>? rents;

  SpaceRentModel.fromJson(Map<String, dynamic> json) {
    final dynamic spaceRentData = json['rent'];
    print('spaceRentData');
    print(spaceRentData);
    if (spaceRentData is List<dynamic>) {
      rents = spaceRentData.map((e) => SpaceRent.fromJson(e)).toList();
      print('rents length');
      print(rents!.length);
    } else if (spaceRentData is Map<String, dynamic>) {
      print("Here");

      rents = [SpaceRent.fromJson(spaceRentData)];
      print("rents");
      print(rents);
    } else {
      print('Invalid activities data: $spaceRentData');
      rents = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rent'] = rents!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SpaceRent {
  final String id;
  final String rentName;
  final String rentspaceId;
  final int currentPayment;
  final String date;
  final bool hasPaid;
  final String dueDate;
  final String interval;
  final int amount;
  final String paymentCount;
  final bool completed;
  final dynamic intervalAmount;
  final dynamic paidAmount;
  final String paymentStatus;
  final String token;
  final String createdAt;
  final String updatedAt;

  SpaceRent({
    required this.id,
    required this.rentName,
    required this.rentspaceId,
    required this.currentPayment,
    required this.date,
    required this.hasPaid,
    required this.dueDate,
    required this.interval,
    required this.amount,
    required this.paymentCount,
    required this.completed,
    required this.intervalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpaceRent.fromJson(Map<String, dynamic> json) => SpaceRent(
        id: json['_id'],
        rentName: json['rentName'],
        rentspaceId: json['rentspace_id'],
        currentPayment: json['current_payment'],
        date: json['date'],
        hasPaid: json['has_paid'],
        dueDate: json['due_date'],
        interval: json['interval'],
        amount: json['amount'],
        paymentCount: json['payment_count'],
        completed: json['completed'],
        intervalAmount: json['interval_amount'],
        paidAmount: json['paid_amount'],
        paymentStatus: json['payment_status'],
        token: json['token'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'rentName': rentName,
        'rentspace_id': rentspaceId,
        'current_payment': currentPayment,
        'date': date,
        'has_paid': hasPaid,
        'due_date': dueDate,
        'interval': interval,
        'amount': amount,
        'payment_count': paymentCount,
        'completed': completed,
        'interval_amount': intervalAmount,
        'paid_amount': paidAmount,
        'payment_status': paymentStatus,
        'token': token,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
