// lib/warshasy.dart - UPDATED
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_router.dart';
import 'package:warshasy/core/theme/app_themes.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/current_user_bloc/current_user_bloc.dart';

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
      MaterialApp.router(
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
    );
  }
}
