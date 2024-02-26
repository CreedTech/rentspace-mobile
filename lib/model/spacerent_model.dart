import 'dart:convert';

class SpaceRentModel {
  SpaceRentModel({
    required this.rent,
  });
  List<SpaceRent>? rent;

  SpaceRentModel.fromJson(Map<String, dynamic> json) {
    final dynamic spaceRentData = json['rent'];
    print('spaceRentData');
    print(spaceRentData);
    if (spaceRentData is Map<String, dynamic>) {
      print("Here");
      // If userDetailsData is a Map, create a single UserDetailsModel object.
      rent = [SpaceRent.fromJson(spaceRentData)];
      print("rent");
      print(rent);
    } else {
      // Handle the case where userDetailsData is not a Map (e.g., it's a List).
      // You might want to log an error or handle this case differently based on your requirements.
      print('spacerentData is not a Map: $spaceRentData');
      // Set userDetails to an empty list or null, depending on your needs.
      rent = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rent'] = rent!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SpaceRent {
  final String id;
  final String rentspaceId;
  final String currentPayment;
  // final String date;
  // final bool hasPaid;
  // final String dueDate;
  // final String interval;
  // final String amount;
  // final String paymentCount;
  // final bool completed;
  // final String intervalAmount;
  // final String paidAmount;
  // final String paymentStatus;
  // // final String token;
  // final String createdAt;
  // final String updatedAt;

  SpaceRent({
    required this.id,
    required this.rentspaceId,
    required this.currentPayment,
    // required this.date,
    // required this.hasPaid,
    // required this.dueDate,
    // required this.interval,
    // required this.amount,
    // required this.paymentCount,
    // required this.completed,
    // required this.intervalAmount,
    // required this.paidAmount,
    // required this.paymentStatus,
    // // required this.token,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory SpaceRent.fromJson(Map<String, dynamic> json) => SpaceRent(
        id: json['_id'],
        rentspaceId: json['rentspace_id'],
        currentPayment: json['current_payment'],
        // date: json['date'],
        // hasPaid: json['has_paid'],
        // dueDate: json['due_date'],
        // interval: json['interval'],
        // amount: json['amount'],
        // paymentCount: json['payment_count'],
        // completed: json['completed'],
        // intervalAmount: json['interval_amount'],
        // paidAmount: json['paid_amount'],
        // paymentStatus: json['payment_status'],
        // // token: json['token'],
        // createdAt: json['createdAt'],
        // updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'rentspace_id': rentspaceId,
        'current_payment': currentPayment,
        // 'date': date,
        // 'has_paid': hasPaid,
        // 'due_date': dueDate,
        // 'interval': interval,
        // 'amount': amount,
        // 'payment_count': paymentCount,
        // 'completed': completed,
        // 'interval_amount': intervalAmount,
        // 'paid_amount': paidAmount,
        // 'payment_status': paymentStatus,
        // // 'token': token,
        // 'createdAt': createdAt,
        // 'updatedAt': updatedAt,
      };
}
