import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerLoader() {
  return ListView(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Shimmer.fromColors(
            baseColor: brandOne.withOpacity(0.2),
            highlightColor: brandTwo.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(const SettingsPage());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 80,
                      height: 16,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
          // Shimmer.fromColors(
          //   baseColor: brandOne.withOpacity(0.2),
          //   highlightColor: brandTwo.withOpacity(0.5),
          //   child: Container(
          //     width: 30,
          //     height: 30,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      const SizedBox(height: 30),
      Shimmer.fromColors(
        baseColor: brandOne.withOpacity(0.2),
        highlightColor: brandTwo.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Container(
            width: 420,
            height: 230,
            decoration: BoxDecoration(
              color: brandOne,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 30),
      Shimmer.fromColors(
        baseColor: brandOne.withOpacity(0.2),
        highlightColor: brandTwo.withOpacity(0.5),
        child: Container(
          width: 420,
          height: 100,
          decoration: BoxDecoration(
            color: brandOne,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      const SizedBox(height: 30),
      Shimmer.fromColors(
        baseColor: brandOne.withOpacity(0.2),
        highlightColor: brandTwo.withOpacity(0.5),
        child: Container(
          width: 400,
          height: 225,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 150,
                      height: 16,
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: 300,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 49,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 100,
                          height: 16,
                          color: Colors.grey[300],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    
      const SizedBox(height: 30),
      Shimmer.fromColors(
        baseColor: brandOne.withOpacity(0.2),
        highlightColor: brandTwo.withOpacity(0.5),
        child: Container(
          width: 400,
          height: 225,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 150,
                      height: 16,
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: 300,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 49,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 100,
                          height: 16,
                          color: Colors.grey[300],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    
    ],
  );
}
