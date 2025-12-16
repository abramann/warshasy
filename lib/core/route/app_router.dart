// lib/core/config/route_config.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/presentation/widgets/in_devlopment_page.dart';
import 'package:warshasy/core/utils/auth_guard.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/auth/presentation/pages/sign_page.dart';
import 'package:warshasy/features/auth/presentation/pages/verify_code_page.dart';
import 'package:warshasy/features/home/presentation/pages/home_page.dart';
import 'package:warshasy/features/home/presentation/pages/subcategories_page.dart';
import 'package:warshasy/features/home/presentation/pages/startup_page.dart';
import 'package:warshasy/features/static_data/domain/entites/service_category.dart';
import 'package:warshasy/features/user/presentation/blocs/current_user_bloc/current_user_bloc.dart';
import 'package:warshasy/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:warshasy/features/user/presentation/pages/profile_page.dart';
import 'package:warshasy/features/user/presentation/pages/profile_setup_page.dart';

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
                        AssignCurrentUserRequested(
                          user:
                              (context.read<CurrentUserBloc>().state
                                      as CurrentUserLoaded)
                                  .user,
                        ),
                      ),
              child: ProfilePage(),
            ),
        routes: [
          GoRoute(
            path: AppRoutePath.profileSetup,
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
        path: AppRoutePath.searchService,
        name: AppRouteName.searchService,
        builder: (context, state) {
          return InDevelopmentPage(featureName: 'Request Service');
        },
      ),
      GoRoute(
        path: '${AppRoutePath.categories}/:categoryId',
        name: AppRouteName.categoryServices,
        builder: (context, state) {
          final categoryId = int.tryParse(
            state.pathParameters['categoryId'] ?? '',
          );
          final categoryExtra = state.extra;
          return SubcategoriesPage(
            categoryId: categoryId ?? 0,
            category: categoryExtra is ServiceCategory ? categoryExtra : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutePath.addService,
        name: AppRouteName.addService,
        builder: (context, state) {
          return InDevelopmentPage(featureName: 'Post Service');
        },
      ),
      GoRoute(
        path: '${AppRoutePath.serviceProviders}/:serviceId',
        name: AppRouteName.serviceProviders,
        builder: (context, state) {
          final id = state.pathParameters['serviceId']!;
          final l = AppLocalizations.of(context);
          return InDevelopmentPage(featureName: 'Service Providers');
        },
      ),
      GoRoute(
        path: AppRoutePath.chats,
        name: AppRouteName.chats,
        builder: (context, state) {
          return InDevelopmentPage(featureName: 'Chats');
        },
      ),
      GoRoute(
        path: '${AppRoutePath.chats}/:chatId',
        name: AppRouteName.chatDetail,
        builder: (context, state) {
          return InDevelopmentPage(featureName: 'Chat');
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
