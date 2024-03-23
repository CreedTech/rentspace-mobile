import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import 'package:http/http.dart' as http;

class BankSelectorOverlay extends StatefulWidget {
  const BankSelectorOverlay({super.key});

  @override
  State<BankSelectorOverlay> createState() => _BankSelectorOverlayState();
}

class _BankSelectorOverlayState extends State<BankSelectorOverlay> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  List<String> _bankName = [];
  String _currentBankName = 'Select bank';
  String? selectedItem;
  String _currentBankCode = '';
  bool _canShowOptions = false;
  bool _isTyping = false;

  List<String> _bankCode = [];
  // bool canShowOption = false;
  getBanksList() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    final response = await http.get(
      Uri.parse(AppConstants.BASE_URL + AppConstants.GET_BANKS_LIST),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
    );
    print('response');
    // print(response);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('jsonResponse');
      // print(jsonResponse);
      List<String> tempName = [];
      List<String> tempCode = [];
      // tempName.add("Select bank");
      for (var item in jsonResponse['banks']) {
        String localCode = item['local_code'] ?? 'N/A';
        // print('localCode');
        // print(localCode);
        String name = item['name'];
        if (localCode != "N/A") {
          tempName.add(name);
          tempCode.add(localCode);
        }
      }
      if (!mounted) return;
      setState(() {
        _bankName = tempName;
        _bankCode = tempCode;

        _canShowOptions = true;
      });
    } else {
      print('Failed to load data from the server');
    }
  }

  @override
  initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    getBanksList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _isTyping = _searchQuery.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            size: 20.sp,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Select Bank',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _canShowOptions
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 16.w,
              ),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TextFormField(
                      style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.sp),
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: false,
                        contentPadding: EdgeInsets.all(3.sp),
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          color: brandOne,
                        ),
                        suffixIcon:
                            _isTyping // Show clear button only when typing
                                ? IconButton(
                                    icon: Icon(
                                      Iconsax.close_circle5,
                                      size: 18.sp,
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      _searchController
                                          .clear(); // Clear the text field
                                    },
                                  )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: brandOne,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: brandOne,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: brandOne,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        hintText: "Search Bank Name",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredBanks.length,
                      itemBuilder: (context, index) {
                        final bankName = _filteredBanks[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: brandTwo.withOpacity(0.1),
                            ),
                            child: ListTile(
                              // tileColor: brandTwo.withOpacity(0.1),
                              // shape: Border,
                              title: Text(
                                bankName,
                                style: GoogleFonts.nunito(
                                  fontSize: 14.sp,
                                  color: brandOne,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _currentBankName = bankName.toString();
                                  selectedItem = bankName;
                                  int index = _bankName.indexOf(selectedItem!);
                                  _currentBankCode = _bankCode[index];
                                });
                                print("_currentBankCode");
                                print(bankName);
                                print(_currentBankCode);
                                Navigator.pop(context, [
                                  bankName,
                                  _currentBankCode
                                ]); //] Pass selected bank back
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CustomLoader(),
            ),
    );
  }

  List<String> get _filteredBanks {
    if (_searchQuery.isEmpty) {
      return _bankName;
    } else {
      return _bankName
          .where((bankName) => bankName.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }
}
