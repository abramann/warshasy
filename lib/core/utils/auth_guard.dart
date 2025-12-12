// lib/core/utils/auth_guard.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/core/route/app_routes.dart';

class AuthGuard {
  Future<String?> handleAuthState(
    BuildContext? context,
    GoRouterState state,
  ) async {
    final location = state.fullPath ?? state.uri.toString();

    // Blocs not initialized yet
    if (location.isEmpty || location == AppRoutePath.root) {
      return null;
    }

    if (context == null) return null;
    final authState = context.read<AuthBloc>().state;

    final isLoggedIn = authState is Authenticated;

    // If public route -> always allow
    if (_isPublicRoute(location)) {
      // Optional: if logged in and trying to visit /login, push them away
      if (isLoggedIn && location.startsWith(AppRoutePath.login)) {
        return AppRoutePath.home;
      }
      return null;
    }

    // Protected routes:
    if (!isLoggedIn) {
      // Save where they wanted to go, so we can maybe use it later
      final from = state.uri.toString();
      return '${AppRoutePath.login}?from=$from';
      return AppRoutePath.login;
    }

    // Signed user + protected route -> allow
    return null;
  }

  bool _isPublicRoute(String location) {
    if (location == AppRoutePath.root) return true;
    if (location == AppRoutePath.home) return true;
    if (location.startsWith(AppRoutePath.login)) return true;

    // Optional: public service detail
    if (location.startsWith(AppRoutePath.serviceDetail)) return true;

    return false;
  }
}
