import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/main.dart';
import 'constants/colors.dart';
import 'internet_connection_provider.dart';

class MyAppWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(internetConnectionProvider).isConnected;

    return Stack(
      children: [
        if (isConnected) const MyApp(),
        if (!isConnected) NoInternetConnectionScreen(),
      ],
    );
  }
}

class NoInternetConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap with Scaffold
      body: Builder(
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // Use Builder to access Scaffold's context
          contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
          elevation: 0.0,
          insetPadding: const EdgeInsets.all(0),
          title: null,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          content: SizedBox(
            height: 170,
            child: Container(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Text(
                    'No internet Connection',
                    style: GoogleFonts.lato(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Example color
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Example color
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Try Again',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // ElevatedButton(

                  //   onPressed: () {
                  //     Navigator.pop(
                  //         context); // Use Navigator.pop with the context provided by Builder
                  //   },
                  //   child: const Text("Try Again"),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
