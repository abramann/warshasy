// lib/warshasy.dart - UPDATED
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_router.dart';
import 'package:warshasy/core/theme/app_themes.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/current_user_bloc/current_user_bloc.dart';
import 'core/utils/injection_container.dart';

class Warshasy extends StatelessWidget {
  const Warshasy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Warshasy',
    );
  }
}
