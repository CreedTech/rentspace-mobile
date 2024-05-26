class ElectricityResponseModel {
  final String status;
  final String message;
  final Data data;

  ElectricityResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ElectricityResponseModel.fromJson(Map<String, dynamic> json) {
    return ElectricityResponseModel(
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  final String status;
  final String message;
  final String code;
  final UserData data;

  Data({
    required this.status,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      status: json['status'],
      message: json['message'],
      code: json['code'],
      data: UserData.fromJson(json['data']['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'code': code,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final String name;
  final String address;
  final String accountNumber;
  final String minimumAmount;
  final RawOutput rawOutput;
  final String? errorMessage;

  UserData({
    required this.name,
    required this.address,
    required this.accountNumber,
    required this.minimumAmount,
    required this.rawOutput,
    this.errorMessage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      address: json['address'],
      accountNumber: json['accountNumber'],
      minimumAmount: json['minimumAmount'],
      rawOutput: RawOutput.fromJson(json['rawOutput']),
      errorMessage: json['errorMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'accountNumber': accountNumber,
      'minimumAmount': minimumAmount,
      'rawOutput': rawOutput.toJson(),
      'errorMessage': errorMessage ?? '',
    };
  }
}

class RawOutput {
  final String address;
  final String outstandingAmount;
  final String name;
  final String minimumAmount;
  final String? customerAccountType;
  final String accountNumber;
  final String customerDtNumber;
  final String customerNumber;
  final String? customerAddress;
  final String vendType;
  final String meterNumber;
  final String? daysSinceLastVend;
  final num minVendAmount;
  final String? maxVendAmount;
  final String? freeUnits;
  final String? company;
  final String? tariff;
  final String? responseMessage;
  final String customerName;
  final String responseCode;

  RawOutput({
    required this.address,
    required this.outstandingAmount,
    required this.name,
    required this.minimumAmount,
    this.customerAccountType,
    required this.accountNumber,
    required this.customerDtNumber,
    required this.customerNumber,
    this.customerAddress,
    required this.vendType,
    required this.meterNumber,
    this.daysSinceLastVend,
    required this.minVendAmount,
    this.maxVendAmount,
    this.freeUnits,
    this.company,
    this.tariff,
    this.responseMessage,
    required this.customerName,
    required this.responseCode,
  });

  factory RawOutput.fromJson(Map<String, dynamic> json) {
    return RawOutput(
      address: json['address'],
      outstandingAmount: json['outstandingAmount'],
      name: json['name'],
      minimumAmount: json['minimumAmount'],
      customerAccountType: json['customerAccountType'] ?? '',
      accountNumber: json['accountNumber'],
      customerDtNumber: json['customerDtNumber'],
      customerNumber: json['customerNumber'],
      customerAddress: json['customerAddress'] ?? '',
      vendType: json['vendType'],
      meterNumber: json['meterNumber'],
      daysSinceLastVend: json['daysSinceLastVend'] ?? '',
      minVendAmount: json['minVendAmount'],
      maxVendAmount: json['maxVendAmount'] ?? '',
      freeUnits: json['freeUnits'] ?? '',
      company: json['company'] ?? '',
      tariff: json['tariff'] ?? '',
      responseMessage: json['responseMessage'] ?? '',
      customerName: json['customerName'],
      responseCode: json['responseCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'outstandingAmount': outstandingAmount,
      'name': name,
      'minimumAmount': minimumAmount,
      'customerAccountType': customerAccountType ?? '',
      'accountNumber': accountNumber,
      'customerDtNumber': customerDtNumber,
      'customerNumber': customerNumber,
      'customerAddress': customerAddress ?? '',
      'vendType': vendType,
      'meterNumber': meterNumber,
      'daysSinceLastVend': daysSinceLastVend ?? '',
      'minVendAmount': minVendAmount,
      'maxVendAmount': maxVendAmount ?? '',
      'freeUnits': freeUnits ?? '',
      'company': company ?? '',
      'tariff': tariff ?? '',
      'responseMessage': responseMessage ?? '',
      'customerName': customerName,
      'responseCode': responseCode,
    };
  }
}
