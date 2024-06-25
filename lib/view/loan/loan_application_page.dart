import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../../constants/colors.dart';
import '../../controller/rent/rent_controller.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key, required this.current});
  final int current;

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _idSelectController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _houseAddressController = TextEditingController();
  final TextEditingController _utilityBillController = TextEditingController();
  final TextEditingController _landLordOrAgentController =
      TextEditingController();
  final TextEditingController _landlordNameController = TextEditingController();
  final TextEditingController _samePropertyController = TextEditingController();
  final TextEditingController _landlordAddressController =
      TextEditingController();
  final TextEditingController _landlordPhoneNumberController =
      TextEditingController();
  final TextEditingController _currentAddressDurationController =
      TextEditingController();
  final TextEditingController _propertyTypesController =
      TextEditingController();
  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0);
  final RentController rentController = Get.find();
  final loanFormKey = GlobalKey<FormState>();
  List<String> idTypes = ['Passport', 'Voter’s ID', 'Driver’s License ', 'NIN'];
  List<String> landordOrAgentTypes = ['Landlord', 'Agent'];
  List<String> samePropertyResponse = ['Yes', 'No'];
  List<String> propertyTypes = ['Residential', 'Commercial'];
  String? selectedId;
  bool isLandlordOrAgentSelected = false;
  bool idSelected = false;
  // late int genderValue;
  @override
  Widget build(BuildContext context) {
    //    void _saveFormData() async {
    //   if (loanFormKey.currentState!.validate()) {
    //     var box = await Hive.openBox<FormData>('loanFormData');
    //     var formData = FormData()
    //       ..name = _nameController.text
    //       ..email = _emailController.text
    //       ..phone = _phoneController.text;
    //     box.put('formData', formData);
    //   }
    // }
    validateReason(lastValue) {
      if (lastValue.isEmpty) {
        return 'Reason cannot be blank';
      }

      return null;
    }

    validateId(lastValue) {
      if (lastValue.isEmpty) {
        return 'ID cannot be empty';
      }
      if (int.tryParse(lastValue) == null) {
        return 'enter valid ID';
      }
    }

    validateIdSelect(lastValue) {
      if (lastValue.isEmpty) {
        return 'You have to select an ID';
      }

      return null;
    }

    validateBvn(bvnValue) {
      if (bvnValue.isEmpty) {
        return 'BVN cannot be empty';
      }
      if (bvnValue.length < 11) {
        return 'BVN is invalid';
      }
      if (bvnValue.length > 11) {
        return 'BVN can not be more than 11 digits';
      }
      if (int.tryParse(bvnValue) == null) {
        return 'enter valid BVN';
      }
      return null;
    }

    validatePhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone number cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone number is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateAddress(lastValue) {
      if (lastValue.isEmpty) {
        return 'Address cannot be empty';
      }
      return null;
    }

    validateBill(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select an image';
      }
      return null;
    }

    validateLandlordOrAgent(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateLandlordName(lastValue) {
      if (lastValue.isEmpty) {
        return 'Enter full name';
      }
      return null;
    }

    validateSameProperty(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateLandlordAddress(lastValue) {
      if (lastValue.isEmpty) {
        return 'Address can not be empty';
      }
      return null;
    }

    validateHowLong(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please enter how long';
      }
      return null;
    }

    validatePropertyType(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateLandLordPhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone number cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone number is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    String formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.startsWith('+234')) {
        // If the number starts with +234, remove the zero after +234 if it exists
        if (phoneNumber.length > 4 && phoneNumber[4] == '0') {
          return '+234${phoneNumber.substring(5)}';
        }
      }
      return phoneNumber;
    }

    // Function to clean up the image name
    String _cleanImageName(String imageName) {
      final RegExp regExp = RegExp(r'image_picker_[\dA-F-]+-');
      return imageName.replaceAll(regExp, '');
    }

    Future<void> _pickImage(BuildContext context, ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100, // Ensure only images are picked
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        print('image file');
        print(imageFile.path);
        // uploadImage(context, imageFile);
        String imageName = path.basename(imageFile.path);
        setState(() {
          _utilityBillController.text = _cleanImageName(imageName);
        });
        print(imageName);
      } else {
        print('No image selected.');
      }
    }

    final reason = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _reasonController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Tell us why you need a loan...',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateReason,
    );

    final selectId = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Select ID',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: idTypes.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          idTypes[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // selected: _selectedCarrier == name[idx],
                                  onTap: () {
                                    print(_idSelectController.text);
                                    setState(() {
                                      selectedId = idTypes[idx];
                                      idSelected = true;
                                      // genderValue =
                                      //     selectedGender == 'Male' ? 1 : 2;
                                    });

                                    _idSelectController.text = idTypes[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != idTypes.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _idSelectController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select ',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateIdSelect,
    );

    final idNumber = TextFormField(
      enableSuggestions: true,
      readOnly: !idSelected,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _idNumberController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Passport, Voter\'s ID, Driver’s License, NIN',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateId,
    );
    final bvn = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _bvnController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '343526475645',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateBvn,
    );
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _phoneNumberController,
      onChanged: (text) {
        // Format the phone number whenever the user types
        String formattedNumber = formatPhoneNumber(text);
        _phoneNumberController.value = _phoneNumberController.value.copyWith(
          text: formattedNumber,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedNumber.length),
          ),
        );
        print(_phoneNumberController.text);
        // print(formattedNumber);
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '+234 8033 865 3475',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validatePhone,
    );
    final address = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _houseAddressController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Include landmarks & closest busstop',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateAddress,
    );

    final utilityBill = TextFormField(
      onTap: () {
        _pickImage(context, ImageSource.gallery);
      },
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _utilityBillController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: true,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'PHCN bill, waste management bill, water bill, bank state...',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Image.asset(
          'assets/icons/camera_icon.png',
          // width: 14,
          // height: 14,
          scale: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateBill,
    );

    final selectLandlordOrAgent = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Landlord Or Agent',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: landordOrAgentTypes.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          landordOrAgentTypes[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(_landLordOrAgentController.text);
                                    setState(() {
                                      selectedId = landordOrAgentTypes[idx];
                                      isLandlordOrAgentSelected = true;
                                    });

                                    _landLordOrAgentController.text =
                                        landordOrAgentTypes[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != landordOrAgentTypes.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _landLordOrAgentController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandlordOrAgent,
    );

    final landlordName = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _landlordNameController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Full name',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandlordName,
    );

    final landlordAddress = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _landlordAddressController,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Include landmarks & closest busstop',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandlordAddress,
    );

    final selectSameProperty = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Does your ${_landLordOrAgentController.text} live on the same property as you?',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: samePropertyResponse.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          samePropertyResponse[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(_samePropertyController.text);
                                    setState(() {
                                      selectedId = samePropertyResponse[idx];
                                    });

                                    _samePropertyController.text =
                                        samePropertyResponse[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != samePropertyResponse.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _samePropertyController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateSameProperty,
    );
    final landlordPhoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _landlordPhoneNumberController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (text) {
        // Format the phone number whenever the user types
        String formattedNumber = formatPhoneNumber(text);
        _landlordPhoneNumberController.value =
            _landlordPhoneNumberController.value.copyWith(
          text: formattedNumber,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedNumber.length),
          ),
        );
      },
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '+234 000-0000-000',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandLordPhone,
    );
    final currentAddressDuration = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _currentAddressDurationController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Input how long',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateHowLong,
    );

    final selectpropertyType = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Type of Property',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: propertyTypes.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          propertyTypes[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(_propertyTypesController.text);
                                    setState(() {
                                      selectedId = propertyTypes[idx];
                                    });

                                    _propertyTypesController.text =
                                        propertyTypes[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != propertyTypes.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _propertyTypesController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validatePropertyType,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  'Loan Application',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Wrap(
                        children: [
                          Text(
                            '${rentController.rentModel!.rents![widget.current].rentName}:',
                            style: GoogleFonts.lato(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            nairaFormaet.format(rentController
                                .rentModel!.rents![widget.current].paidAmount),
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: loanFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Reason',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              reason,
                            ],
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Personal Verification',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'ID',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: selectId,
                                  ),
                                  SizedBox(
                                    width: 11.w,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Opacity(
                                        opacity: (idSelected == true) ? 1 : 0.5,
                                        child: idNumber),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'BVN',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              bvn,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Phone Number',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              phoneNumber,
                            ],
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Proof of Residence',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'House Address',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              address,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Utility Bill',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              utilityBill,
                            ],
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Landlord/Agent Verification',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Landlord or Agent',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              selectLandlordOrAgent,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // (isLandlordOrAgentSelected)
                          Visibility(
                            visible: isLandlordOrAgentSelected,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        '${_landLordOrAgentController.text} Name',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    landlordName,
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Does your ${_landLordOrAgentController.text} live on the same property as you?',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    selectSameProperty,
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        '${_landLordOrAgentController.text} Address',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    landlordAddress,
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        '${_landLordOrAgentController.text} Phone Number',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    landlordPhoneNumber,
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'How long have you been living at your current address?',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    currentAddressDuration,
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Type of Property',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    selectpropertyType,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 50, 50),
                    backgroundColor: brandTwo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (loanFormKey.currentState!.validate()) {}
                  },
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
