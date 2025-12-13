// lib/core/config/route_config.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/utils/auth_guard.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/auth/presentation/pages/sign_page.dart';
import 'package:warshasy/features/auth/presentation/pages/verify_code_page.dart';
import 'package:warshasy/features/home/presentation/pages/home_page.dart';
import 'package:warshasy/features/home/presentation/pages/startup_page.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/current_user_bloc/current_user_bloc.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc/user_bloc.dart';
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
    initialLocation: AppRoutePath.root,
    //refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) => _authGuard.handleAuthState(context, state),
    routes: [
      // ROOT -> HOME
      GoRoute(
        path: AppRoutePath.root,
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: StartupPage()),
      ),

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
            path: AppRoutePath.verifyCode,
            name: AppRouteName.verifyCode,
            builder: (context, state) {
              return VerifyCodePage();
            },
          ),
        ],
      ),

      // PROFILE (SIGNED)
      GoRoute(
        path: AppRoutePath.profile,
        name: AppRouteName.profile,
        builder:
            (context, state) => BlocProvider(
              create:
                  (context) =>
                      sl<UserBloc>()..add(
                        LoadUserRequested(
                          userId:
                              (context.read<CurrentUserBloc>().state
                                      as CurrentUserLoaded)
                                  .user
                                  .id,
                        ),
                      ),
              child: ProfilePage(),
            ),
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
              return BlocProvider(
                create:
                    (context) =>
                        sl<UserBloc>()..add(
                          LoadUserRequested(
                            userId: state.pathParameters['id']!,
                          ),
                        ),
                child: ProfilePage(),
              );
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
          final l = AppLocalizations.of(context);
          return Scaffold(
            appBar: AppBar(title: Text(l.serviceDetailsTitle)),
            body: Center(child: Text(l.serviceIdLabel(id))),
          );
        },
      ),

      // CHATS (SIGNED)
      GoRoute(
        path: AppRoutePath.chats,
        name: AppRouteName.chats,
        builder: (context, state) {
          // TODO: replace with chat list widget
          final l = AppLocalizations.of(context);
          return Scaffold(body: Center(child: Text(l.chatsListTitle)));
        },
      ),
      GoRoute(
        path: '${AppRoutePath.chats}/:chatId',
        name: AppRouteName.chatDetail,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          final l = AppLocalizations.of(context);
          // TODO: replace with chat screen
          return Scaffold(
            appBar: AppBar(title: Text(l.chatTitle)),
            body: Center(child: Text('${l.chatTitle} #$chatId')),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      final l = AppLocalizations.of(context);
      return Scaffold(
        body: Center(child: Text('${l.pageNotFoundWithUri} ${state.uri}')),
      );
    },
  );
}
