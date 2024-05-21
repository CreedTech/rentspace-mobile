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
  // String bundleType;

  DataBundle({
    required this.amount,
    required this.name,
    required this.validity,
    // required this.bundleType,
  });

  factory DataBundle.fromJson(Map<String, dynamic> json) {
    return DataBundle(
      amount: json['amount'],
      name: json['name'],
      validity: json['validity'],
      // bundleType: json['bundle_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'name': name,
      'validity': validity,
      // 'bundle_type': bundleType,
    };
  }
}
