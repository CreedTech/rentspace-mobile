class ReferralModel {
  ReferralModel({
    required this.referrals,
  });
  List<Referral>? referrals;

  ReferralModel.fromJson(Map<String, dynamic> json) {
    final dynamic referralData = json['referredUsers'];
    print('referralData');
    // print(referralData);
    if (referralData is List<dynamic>) {
      referrals = referralData.map((e) => Referral.fromJson(e)).toList();
      print('referrals length');
      // print(referrals!.length);
    } else if (referralData is Map<String, dynamic>) {
      print("Here");

      referrals = [Referral.fromJson(referralData)];
      print("referrals");
      // print(referrals);
    } else {
      // print('Invalid referral data: $referralData');
      referrals = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['referredUsers'] = referrals!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Referral {
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
  final String nextDate;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> rentHistories;

  Referral(
      {required this.id,
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
      required this.nextDate,
      required this.createdAt,
      required this.updatedAt,
      required this.rentHistories});

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
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
      nextDate: json['next_date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      rentHistories: json["rentHistories"]);

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
        'next_date': nextDate,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'rentHistories': rentHistories
      };
}
