import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/constants/constants.dart';
import 'package:warshasy/core/theme/app_gradients.dart';
import 'package:warshasy/features/auth/auth.dart';

class CommonWidgets {
  static PreferredSizeWidget buildDefaultAppBar(
    BuildContext context, {
    String title = AppStrings.appName,
  }) {
    // Will cause a rebuild when auth state changes
    final isAuthenticated = context.select<AuthBloc, bool>(
      (bloc) => bloc.state is Authenticated,
    );

    return AppBar(
      title: Text(title),
      actions: [
        if (context.canPop())
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          )
        else if (isAuthenticated)
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
          ),
        // else: no icon at all when unauthenticated
      ],
    );
  }
}
