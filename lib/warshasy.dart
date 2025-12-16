// lib/warshasy.dart - UPDATED with persistent auth listener
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_router.dart';
import 'package:warshasy/core/theme/app_themes.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/user/presentation/blocs/current_user_bloc/current_user_bloc.dart';

class Warshasy extends StatelessWidget {
  const Warshasy({super.key});

  Widget _setupBlocProviders(BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<StaticDataBloc>()),
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<CurrentUserBloc>()),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _setupBlocProviders(
      context,
      // Wrap MaterialApp.router with AuthStateListener
      _AuthStateListener(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          title: 'Warshasy',
        ),
      ),
    );
  }
}

// ============================================
// Persistent Auth State Listener
// ============================================
class _AuthStateListener extends StatelessWidget {
  final Widget child;

  const _AuthStateListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // This listener persists throughout the app lifecycle
      listener: (context, authState) {
        if (authState is Authenticated) {
          // Load current user when authenticated
          context.read<CurrentUserBloc>().add(
            LoadCurrentUser(userId: authState.session.userId),
          );
        } else if (authState is Unauthenticated) {
          // Clear current user when logged out
          context.read<CurrentUserBloc>().add(ClearCurrentUser());
        }
        // You can add more auth state handling here if needed
      },
      child: child,
    );
  }
}
