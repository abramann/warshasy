import 'package:flutter/material.dart';

/// Base page that applies common wrappers (RTL + SafeArea) to every screen.
class BasePage extends StatelessWidget {
  final Widget child;
  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: child);
  }
}
