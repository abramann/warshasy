import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_router.dart';
import 'package:warshasy/core/route/app_routes.dart';

class CustomerScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  const CustomerScaffold({required this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _customerIndexFromLocation(context.currentUri),
        onTap: (index) {
          switch (index) {
            case 0:
              context.goNamed(AppRouteName.home);
              break;
            case 1:
              context.goNamed(AppRouteName.home);
              context.pushNamed(AppRouteName.chats);
              break;
            case 2:
              context.goNamed(AppRouteName.home);
              context.pushNamed(AppRouteName.profile);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: l.navChats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l.navProfile,
          ),
        ],
      ),
    );
  }

  int _customerIndexFromLocation(String location) {
    if (location.startsWith('${AppRoutePath.home}')) return 0;
    if (location.startsWith('${AppRoutePath.chats}')) return 1;
    if (location.startsWith('${AppRoutePath.profile}')) return 2;
    return 0;
  }
}
