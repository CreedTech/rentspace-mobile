import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/separator.dart';
import '../FirstPage.dart';
import '../savings/spaceRent/spacerent_list.dart';

class ReferralRecord extends StatefulWidget {
  const ReferralRecord({super.key});

  @override
  State<ReferralRecord> createState() => _ReferralRecordState();
}

class _ReferralRecordState extends State<ReferralRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandTwo.withOpacity(0.2),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Referral Record',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 5.h,
          ),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Earned',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          ch8t.format(
                            userController
                                .userModel!.userDetails![0].referralPoints,
                          ),
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Referred Users',
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          userController.userModel!.userDetails![0].referrals
                              .toString(),
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        'Referred Users',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35.w,
                        ),
                        child: MySeparator(
                          color: brandOne.withOpacity(0.2),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      (userController.userModel!.userDetails![0].referredUsers
                              .isNotEmpty)
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: userController.userModel!
                                  .userDetails![0].referredUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                int reversedIndex = userController.userModel!
                                        .userDetails![0].referredUsers.length -
                                    1 -
                                    index;
                                final history = userController
                                    .userModel!
                                    .userDetails![0]
                                    .referredUsers[reversedIndex];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 0,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(50.sp),
                                      child: CachedNetworkImage(
                                        imageUrl: history['avatar']['url'],
                                        height: 30.h,
                                        width: 30.w,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Image.asset(
                                            'assets/icons/RentSpace-icon.png',
                                            height: 30.h,
                                            width: 30.w,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                            'assets/icons/RentSpace-icon.png',
                                            height: 30.h,
                                            width: 30.w,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        // progressIndicatorBuilder:
                                        //     (context, url, progress) {
                                        //   return const CustomLoader();
                                        // },
                                      ),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${history['lastName']} ${history['firstName']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunito(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    history['email'],
                                    style: GoogleFonts.nunito(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: (history[
                                                  'has_received_referral_bonus'] ==
                                              true)
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      (history['has_received_referral_bonus'] ==
                                              false)
                                          ? "waiting"
                                          : 'done',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        fontSize: 10.0.sp,
                                        // fontFamily: "DefaultFontFamily",
                                        // letterSpacing: 0.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: Text(
                                  "No Referred User",
                                  style: GoogleFonts.nunito(
                                    fontSize: 12.sp,
                                    // fontFamily: "DefaultFontFamily",
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
