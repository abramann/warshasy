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

    if (authState is! AuthSuccess && isSignedUserRoute(state.fullPath!)) {
      return '/profile-setup';
    }
    //if (!(authState is AuthSuccess) && !isPublicRoute(state.fullPath!)) {
    //  return '/login';
    //}
    return null;
  }

  bool isSignedUserRoute(String location) {
    return location.startsWith('/user') || location.startsWith('/profile');
  }
}
