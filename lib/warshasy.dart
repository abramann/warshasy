// lib/warshasy.dart - UPDATED
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_router.dart';
import 'package:warshasy/core/theme/app_themes.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/database/domain/presentation/bloc/database_bloc.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';
import 'core/utils/injection_container.dart';

class Warshasy extends StatelessWidget {
  const Warshasy({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();
    final userBloc = sl<UserBloc>();
    final databaseBloc = sl<DatabaseBloc>();

    // Initialize blocs
    authBloc.add(AuthStartup());
    databaseBloc.add(LoadDatabaseData()); // Load database data at startup

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: userBloc),
        BlocProvider.value(value: databaseBloc), // Add database bloc
      ],
      child: MultiBlocListener(
        listeners: [
          // Auth listener
          BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is Authenticated) {
                context.read<UserBloc>().add(
                  LoadUserRequested(userId: authState.session.userId),
                );
              } else if (authState is Unauthenticated) {
                context.read<UserBloc>().add(ClearUserRequested());
              }
            },
          ),

          // Database listener (optional - for error handling)
          BlocListener<DatabaseBloc, DatabaseState>(
            listener: (context, databaseState) {
              if (databaseState is DatabaseError) {
                // Show error notification or retry
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'فشل في تحميل البيانات: ${databaseState.failure.message}',
                    ),
                    action: SnackBarAction(
                      label: 'إعادة المحاولة',
                      onPressed: () {
                        context.read<DatabaseBloc>().add(
                          LoadDatabaseData(forceRefresh: true),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter(authBloc).router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
  }
}
