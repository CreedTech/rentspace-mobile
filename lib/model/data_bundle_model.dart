class DataBundleResponse {
  List<DataBundle> amountOptions;

  DataBundleResponse({required this.amountOptions});

  factory DataBundleResponse.fromJson(Map<String, dynamic> json) {
    return DataBundleResponse(
      amountOptions: List<DataBundle>.from(json['amount_options'].map((x) => DataBundle.fromJson(x))),
    );
  }
}

class DataBundle {
  String amount;
  String name;
  String validity;

  DataBundle({
    required this.amount,
    required this.name,
    required this.validity,
  });

  factory DataBundle.fromJson(Map<String, dynamic> json) {
    return DataBundle(
      amount: json['amount'],
      name: json['name'],
      validity: json['validity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'name': name,
      'validity': validity,
    };
  }
}
