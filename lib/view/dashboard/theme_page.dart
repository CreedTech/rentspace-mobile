import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../controller/theme/theme_controller.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final ThemeController themeController = Get.find<ThemeController>();
  // ThemeMode _selectedTheme = ThemeMode.system;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
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
                Text(
                  'Dark Mode',
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(() {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 24.w,
              ),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 17, top: 10, right: 17, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color:
                          //         Colors.grey.withOpacity(0.1), // Shadow color
                          //     spreadRadius: 0.5, // Spread radius
                          //     blurRadius: 2, // Blur radius
                          //     offset: const Offset(0, 3), // Offset
                          //   ),
                          // ],
                          color: Theme.of(context).canvasColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              // horizontalTitleGap: 0,
                              minLeadingWidth: 0,
                              // onTap: () {
                              //   setState(() {
                              //     isSelected = !isSelected;
                              //   });
                              // },
                              // selected: true,
                              title: Text(
                                "Automatic",
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),

                              // trailing: _selectedTheme == ThemeMode.system
                              //     ? const Icon(Icons.check)
                              //     : null,
                              // onTap: () {
                              //   setState(() {
                              //     _selectedTheme = ThemeMode.system;
                              //   });
                              // },
                              trailing: themeController.currentThemeMode ==
                                      AppThemeMode.system
                                  ? Icon(
                                      Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : null,
                              onTap: () => themeController
                                  .changeTheme(AppThemeMode.system),
                            ),
                            Divider(
                              color: Theme.of(context).dividerColor,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              // horizontalTitleGap: 0,
                              minLeadingWidth: 0,
                              // onTap: () {
                              //   setState(() {
                              //     !isSelected;
                              //   });
                              // },
                              title: Text(
                                'Light Mode',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              // trailing: _selectedTheme == ThemeMode.light
                              //     ? const Icon(Icons.check)
                              //     : null,
                              // onTap: () {
                              //   setState(() {
                              //     _selectedTheme = ThemeMode.light;
                              //   });
                              // },

                              trailing: themeController.currentThemeMode ==
                                      AppThemeMode.light
                                  ? Icon(
                                      Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : null,
                              onTap: () => themeController
                                  .changeTheme(AppThemeMode.light),
                            ),
                             Divider(
                              color: Theme.of(context).dividerColor,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              // horizontalTitleGap: 0,
                              minLeadingWidth: 0,
                              // onTap: () {
                              //   setState(() {
                              //     !isSelected;
                              //   });
                              // },
                              title: Text(
                                'Dark Mode',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),

                              // trailing: _selectedTheme == ThemeMode.dark
                              //     ? Icon(
                              // Icons.check,
                              // )
                              //     : null,
                              // onTap: () {
                              //   setState(() {
                              //     _selectedTheme = ThemeMode.dark;
                              //   });
                              // },
                              trailing: themeController.currentThemeMode ==
                                      AppThemeMode.dark
                                  ? Icon(
                                      Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : null,
                              onTap: () => themeController
                                  .changeTheme(AppThemeMode.dark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
