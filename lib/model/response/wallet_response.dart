import 'package:rentspace/model/wallet_model.dart';

class WalletResponse {
  String? msg;
  List<Wallet> wallet;

  WalletResponse({required this.msg, required this.wallet});

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    // Check if 'wallet' exists and is a list
    if (json.containsKey('wallet') && json['wallet'] is List) {
      var walletInfo = json['wallet'] as List<dynamic>;
      List<Wallet> details =
          walletInfo.map((walletJson) => Wallet.fromJson(walletJson)).toList();
      return WalletResponse(
        msg: json['msg'] as String,
        wallet: details,
      );
    } else {
      // If 'walletInfos' is not a list, handle it accordingly
      // For example, you can create a single Wallet object
      Wallet walletInfo = Wallet.fromJson(json['wallet']);
      return WalletResponse(
        msg: json['msg'] as String,
        wallet: [walletInfo],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'wallet': wallet.map((wallet) => wallet.toJson()).toList(),
    };
  }
}
