import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_router.dart';
import 'package:warshasy/core/theme/app_themes.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';
import 'core/utils/injection_container.dart';

class Warshasy extends StatelessWidget {
  const Warshasy({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();
    final userBloc = sl<UserBloc>(); // Single instance

    authBloc.add(AuthStartup());

    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc
        BlocProvider.value(value: authBloc),

        // Provide UserBloc
        BlocProvider.value(value: userBloc),
      ],

      // Listen to auth state and load user when authenticated
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is Authenticated) {
            // Load user data when authenticated
            context.read<UserBloc>().add(
              LoadUserRequested(userId: authState.session.userId),
            );
          } else if (authState is Unauthenticated) {
            // Clear user data when logged out
            context.read<UserBloc>().add(ClearUserRequested());
          }
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter(authBloc).router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
  }
}
