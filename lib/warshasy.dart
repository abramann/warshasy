import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/config/route_config.dart';
import 'package:warshasy/core/presentation/theme/app_theme.dart';
import 'package:warshasy/core/presentation/widgets/bloc_error_listner.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'core/config/injection_container.dart';

class Warshasy extends StatelessWidget {
  const Warshasy({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();
    authBloc.add(AuthStartup());

    return MultiBlocProvider(
      providers: [BlocProvider.value(value: authBloc)],
      child: Builder(
        builder:
            (context) => BlocErrorListener<AuthBloc, AuthState>(
              // ✅ Global error handling for AuthBloc
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter(authBloc).router,
                theme: AppTheme.lightTheme(),
              ),
            ),
      ),
    );
  }
}
