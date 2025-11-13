import 'package:flutter/material.dart';

class TryAgainPage extends StatelessWidget {
  final String? message;
  final VoidCallback onPressedTryAgain;

  const TryAgainPage({Key? key, this.message, required this.onPressedTryAgain})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64),
              const SizedBox(height: 16),
              Text(message ?? 'Error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onPressedTryAgain,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
