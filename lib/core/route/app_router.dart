// lib/core/config/route_config.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/utils/auth_guard.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/auth/presentation/pages/sign_page.dart';
import 'package:warshasy/features/auth/presentation/pages/verify_code_page.dart';
import 'package:warshasy/features/home/presentation/pages/home_page.dart';
import 'package:warshasy/features/user/domain/presentation/pages/profile_page.dart';
import 'package:warshasy/features/user/domain/presentation/pages/profile_setup_page.dart';

import 'app_routes.dart';

extension GoRouterContextX on BuildContext {
  String? get fullPath => GoRouterState.of(this).fullPath?.toString();
  String get currentUri => GoRouterState.of(this).uri.toString();
}

class AppRouter {
  static final AuthGuard _authGuard = AuthGuard();

  AppRouter._();
  static String getCurrentRoute(BuildContext ctx) =>
      GoRouterState.of(ctx).uri.toString();
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutePath.home,
    //refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) => _authGuard.handleAuthState(context, state),
    routes: [
      // ROOT -> HOME
      GoRoute(path: AppRoutePath.root, redirect: (_, __) => AppRoutePath.home),

      // PUBLIC HOME
      GoRoute(
        path: AppRoutePath.home,
        name: AppRouteName.home,
        builder: (context, state) => const HomePage(),
      ),

      // AUTH (PUBLIC)
      GoRoute(
        path: AppRoutePath.login,
        name: AppRouteName.login,
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const SignPage()),
        routes: [
          GoRoute(
            path: 'verify-code',
            name: AppRouteName.verifyCode,
            builder: (context, state) {
              final phone = state.extra as String;
              return VerifyCodePage(phoneNumber: phone);
            },
          ),
        ],
      ),

      // PROFILE (SIGNED)
      GoRoute(
        path: AppRoutePath.profile,
        name: AppRouteName.profile,
        builder: (context, state) => ProfilePage(),
        routes: [
          GoRoute(
            path: 'profile-setup',
            name: AppRouteName.profileSetup,
            builder: (context, state) => const ProfileSetupPage(),
          ),
          GoRoute(
            path: ':id',
            name: AppRouteName.profileDetail,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProfilePage(userId: id);
            },
          ),
        ],
      ),

      // SERVICES (SIGNED)
      GoRoute(
        path: AppRoutePath.requestService,
        name: AppRouteName.requestService,
        builder: (context, state) {
          final l = AppLocalizations.of(context);
          // TODO: replace with real widget
          return Scaffold(body: Center(child: Text(l.requestService)));
        },
      ),
      GoRoute(
        path: AppRoutePath.postService,
        name: AppRouteName.addService,
        builder: (context, state) {
          final l = AppLocalizations.of(context);
          // TODO: replace with real widget
          return Scaffold(body: Center(child: Text(l.postService)));
        },
      ),
      GoRoute(
        path: '${AppRoutePath.serviceDetail}/:serviceId',
        name: AppRouteName.serviceDetail,
        builder: (context, state) {
          final id = state.pathParameters['serviceId']!;
          // This one can be public or protected
          return Scaffold(
            appBar: AppBar(title: const Text('Service details')),
            body: Center(child: Text('Service ID: $id')),
          );
        },
      ),

      // CHATS (SIGNED)
      GoRoute(
        path: AppRoutePath.chats,
        name: AppRouteName.chats,
        builder: (context, state) {
          // TODO: replace with chat list widget
          return const Scaffold(body: Center(child: Text('Chats list')));
        },
      ),
      GoRoute(
        path: '${AppRoutePath.chats}/:chatId',
        name: AppRouteName.chatDetail,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          // TODO: replace with chat screen
          return Scaffold(
            appBar: AppBar(title: const Text('Chat')),
            body: Center(child: Text('Chat ID: $chatId')),
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
