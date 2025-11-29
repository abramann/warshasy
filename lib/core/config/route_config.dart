import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/config/config.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/home/presentation/pages/home_page.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/auth/presentation/pages/sign_page.dart';
import 'package:warshasy/core/utils/auth_guard.dart';
import 'package:warshasy/features/auth/presentation/pages/verify_code_page.dart';
import 'package:warshasy/features/user/domain/presentation/pages/profile_page.dart';
import 'package:warshasy/features/user/domain/presentation/pages/profile_setup_page.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final AuthGuard _authGuard = AuthGuard(authBloc);

  late final GoRouter router = GoRouter(
    // Where to start
    initialLocation: '/home',

    // Refresh router when auth state changes
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    // Redirect logic based on auth state
    redirect: (context, state) => _authGuard.handleAuthState(context, state),

    // All routes
    routes: [
      // ==========================================
      // AUTH ROUTES (Public - No auth needed)
      // ==========================================

      // Login Page
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder:
            (context, state) => MaterialPage(
              key: state.pageKey,
              child: BlocProvider.value(
                value: authBloc,
                child: const SignPage(),
              ),
            ),
        routes: [
          GoRoute(
            path: 'verify-code',
            name: 'verify-code',
            builder: (context, state) {
              return BlocProvider.value(
                value: authBloc,
                child: VerifyCodePage(phoneNumber: state.extra as String),
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          // Show the user's own profile by default
          return ProfilePage();
        }, // Redirect to default child
        routes: [
          GoRoute(
            path: 'profile-setup',
            name: 'profile-setup',
            builder: (context, state) => const ProfileSetupPage(),
          ),
          GoRoute(
            path: ':id', // → /profile/:id
            name: 'profile-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProfilePage(userId: id);
            },
          ),
        ],
      ),

      // ==========================================
      // ==========================================
      GoRoute(
        path: '/home',
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: authBloc),
                BlocProvider(create: (context) => sl<UserBloc>()),
              ],
              child: const HomePage(),
            ),
        routes: [],
      ),

      // Root redirect
      GoRoute(path: '/', redirect: (context, state) => '/home'),
    ],
    // Error page
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}

// Helper class to make GoRouter listen to BLoC stream
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
