import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentspace/main.dart';
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
                    const Text(
                      'No internet Connection',
                      style: TextStyle(
                        color: Colors.blue, // Example color
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue, // Example color
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Use Navigator.pop with the context provided by Builder
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
