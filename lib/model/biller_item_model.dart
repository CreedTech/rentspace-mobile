
class BillerItemResponseModel {
  String status;
  String message;
  Data data;

  BillerItemResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BillerItemResponseModel.fromJson(Map<String, dynamic> json) {
    return BillerItemResponseModel(
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
  List<BillerItem> paymentItems;

  Data({
    required this.paymentItems,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final dynamic paymentItemsData = json['paymentitems'];
    // print('paymentItemsData');
    // print(paymentItemsData);
    if (paymentItemsData is List<dynamic>) {
      // print('rents length');
      return Data(
        paymentItems:
            paymentItemsData.map((e) => BillerItem.fromJson(e)).toList(),
      );

    } else if (paymentItemsData is Map<String, dynamic>) {
      return Data(
        paymentItems: [BillerItem.fromJson(paymentItemsData)],
      );
    } else {
      return Data(paymentItems: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentitems': paymentItems.map((item) => item.toJson()).toList(),
    };
  }
}

class BillerItem {
  String categoryId;
  String billerId;
  String isAmountFixed;
  String paymentItemId;
  String paymentItemName;
  String amount;
  String billerType;
  String code;
  String currencyCode;
  String currencySymbol;
  String itemCurrencySymbol;
  String sortOrder;
  String pictureId;
  String paymentCode;
  String itemFee;
  String payDirectItemCode;
  String productId;
  String division;

  BillerItem({
    required this.categoryId,
    required this.billerId,
    required this.isAmountFixed,
    required this.paymentItemId,
    required this.paymentItemName,
    required this.amount,
    required this.billerType,
    required this.code,
    required this.currencyCode,
    required this.currencySymbol,
    required this.itemCurrencySymbol,
    required this.sortOrder,
    required this.pictureId,
    required this.paymentCode,
    required this.itemFee,
    required this.payDirectItemCode,
    required this.productId,
    required this.division,
  });

  factory BillerItem.fromJson(Map<String, dynamic> json) {
    return BillerItem(
      categoryId: json['categoryid'].toString(),
      billerId: json['billerid'].toString(),
      isAmountFixed: json['isAmountFixed'].toString(),
      paymentItemId: json['paymentitemid'].toString(),
      paymentItemName: json['paymentitemname'].toString(),
      amount: json['amount'].toString(),
      billerType: json['billerType'].toString(),
      code: json['code'].toString(),
      currencyCode: json['currencyCode'].toString(),
      currencySymbol: json['currencySymbol'].toString(),
      itemCurrencySymbol: json['itemCurrencySymbol'].toString(),
      sortOrder: json['sortOrder'].toString(),
      pictureId: json['pictureId'].toString(),
      paymentCode: json['paymentCode'].toString(),
      itemFee: json['itemFee'].toString(),
      payDirectItemCode: json['paydirectItemCode'].toString(),
      productId: json['productId'].toString(),
      division: json['division'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryid': categoryId,
      'billerid': billerId,
      'isAmountFixed': isAmountFixed,
      'paymentitemid': paymentItemId,
      'paymentitemname': paymentItemName,
      'amount': amount,
      'billerType': billerType,
      'code': code,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'itemCurrencySymbol': itemCurrencySymbol,
      'sortOrder': sortOrder,
      'pictureId': pictureId,
      'paymentCode': paymentCode,
      'itemFee': itemFee,
      'paydirectItemCode': payDirectItemCode,
      'productId': productId,
      'division': division,
    };
  }
}
