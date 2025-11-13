import 'package:flutter/material.dart';
import 'package:warshasy/core/config/route_config.dart';
import 'package:warshasy/core/presentation/theme/app_theme.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'core/config/injection_container.dart';

class Warshasy extends StatelessWidget {
  const Warshasy({super.key});

  @override
  Widget build(BuildContext context) {
    // Create AuthBloc instance
    final authBloc = sl<AuthBloc>();

    authBloc.add(AuthStartup(context: context));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter(authBloc).router,
      theme: AppTheme.lightTheme(),
    );
  }
}
