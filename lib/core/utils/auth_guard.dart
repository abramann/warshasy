import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/config/injection_container.dart';
import 'package:warshasy/core/storage/repository/local_storage_reposotory.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';

class AuthGuard {
  final AuthBloc authBloc;

  AuthGuard(this.authBloc);

  Future<String?> handleAuthState(
    BuildContext? context,
    GoRouterState state,
  ) async {
    final authState = authBloc.state;

    // If user is authenticated, allow access to signed routes
    if (authState is AuthSuccess) {
      return null; // Allow navigation
    }

    // If user is NOT authenticated and trying to access protected routes
    if (isSignedUserRoute(state.fullPath!)) {
      return '/login'; // Redirect to login
    }

    return null;
  }

  bool isSignedUserRoute(String location) {
    if (location.startsWith('/login')) return false;
    if (location == '/home') return false;
    return true;
  }
}
