import 'dart:convert';

List<SpaceRent> rentModelFromJson(String? str) {
  if (str == null) {
    throw const FormatException('Input string is null');
  }

  final decoded = json.decode(str);

  if (decoded is List) {
    return List<SpaceRent>.from(
        decoded.map((x) => SpaceRent.fromJson(x)));
  } else if (decoded is Map<String, dynamic>) {
    // Adjust this part based on your actual JSON structure
    // If it's a map, you might want to handle it differently
    return [SpaceRent.fromJson(decoded)];
  } else {
    throw const FormatException('Invalid JSON format');
  }
}

String rentModelToJson(List<SpaceRent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));




class SpaceRent {
    final String id;
    final String rentspaceId;
    final int currentPayment;
    final DateTime date;
    final bool hasPaid;
    final DateTime dueDate;
    final String interval;
    final int amount;
    final String paymentCount;
    final bool completed;
    final int intervalAmount;
    final int paidAmount;
    final String paymentStatus;
    final String token;
    final DateTime createdAt;
    final DateTime updatedAt;

    SpaceRent({
        required this.id,
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


factory SpaceRent.fromJson(Map<String, dynamic> json) {
    return SpaceRent(
      id: json['id'],
      rentspaceId: json['rentspaceId'],
      currentPayment: json['currentPayment'],
      date: DateTime.parse(json['date']),
      hasPaid: json['hasPaid'],
      dueDate: DateTime.parse(json['dueDate']),
      interval: json['interval'],
      amount: json['amount'],
      paymentCount: json['paymentCount'],
      completed: json['completed'],
      intervalAmount: json['intervalAmount'],
      paidAmount: json['paidAmount'],
      paymentStatus: json['paymentStatus'],
      token: json['token'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rentspaceId': rentspaceId,
      'currentPayment': currentPayment,
      'date': date.toIso8601String(),
      'hasPaid': hasPaid,
      'dueDate': dueDate.toIso8601String(),
      'interval': interval,
      'amount': amount,
      'paymentCount': paymentCount,
      'completed': completed,
      'intervalAmount': intervalAmount,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

