
class CustomerResponseModel {
  String status;
  String message;
  Data data;

  CustomerResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
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
  String status;
  String message;
  String code;
  UserData data;

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
  String name;
  double outstandingBalance;
  DateTime dueDate;
  String accountNumber;
  RawOutput rawOutput;
  bool hasDiscount;
  CurrentBouquetRaw currentBouquetRaw;
  String currentBouquet;
  String? errorMessage;

  UserData({
    required this.name,
    required this.outstandingBalance,
    required this.dueDate,
    required this.accountNumber,
    required this.rawOutput,
    required this.hasDiscount,
    required this.currentBouquetRaw,
    required this.currentBouquet,
    this.errorMessage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      outstandingBalance: json['outstandingBalance'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      accountNumber: json['accountNumber'],
      rawOutput: RawOutput.fromJson(json['rawOutput']),
      hasDiscount: json['hasDiscount'],
      currentBouquetRaw: CurrentBouquetRaw.fromJson(json['currentBouquetRaw']),
      currentBouquet: json['currentBouquet'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'outstandingBalance': outstandingBalance,
      'dueDate': dueDate.toIso8601String(),
      'accountNumber': accountNumber,
      'rawOutput': rawOutput.toJson(),
      'hasDiscount': hasDiscount,
      'currentBouquetRaw': currentBouquetRaw.toJson(),
      'currentBouquet': currentBouquet,
      'errorMessage': errorMessage,
    };
  }
}

class RawOutput {
  DateTime dueDate;
  String lastName;
  String firstName;
  String customerType;
  String accountStatus;
  int invoicePeriod;
  String customerNumber;

  RawOutput({
    required this.dueDate,
    required this.lastName,
    required this.firstName,
    required this.customerType,
    required this.accountStatus,
    required this.invoicePeriod,
    required this.customerNumber,
  });

  factory RawOutput.fromJson(Map<String, dynamic> json) {
    return RawOutput(
      dueDate: DateTime.parse(json['dueDate']),
      lastName: json['lastName'],
      firstName: json['firstName'],
      customerType: json['customerType'],
      accountStatus: json['accountStatus'],
      invoicePeriod: json['invoicePeriod'],
      customerNumber: json['customerNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dueDate': dueDate.toIso8601String(),
      'lastName': lastName,
      'firstName': firstName,
      'customerType': customerType,
      'accountStatus': accountStatus,
      'invoicePeriod': invoicePeriod,
      'customerNumber': customerNumber,
    };
  }
}

class CurrentBouquetRaw {
  List<Item> items;
  double amount;

  CurrentBouquetRaw({
    required this.items,
    required this.amount,
  });

  factory CurrentBouquetRaw.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List;
    List<Item> itemListParsed = itemList.map((i) => Item.fromJson(i)).toList();

    return CurrentBouquetRaw(
      items: itemListParsed,
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'amount': amount,
    };
  }
}

class Item {
  String code;
  String name;
  double price;
  String description;

  Item({
    required this.code,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      code: json['code'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}
