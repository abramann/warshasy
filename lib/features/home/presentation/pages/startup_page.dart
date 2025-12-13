import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/constants/constants.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_routes.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/core/utils/snackbar_utils.dart';
import 'package:warshasy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/current_user_bloc/current_user_bloc.dart';

class StartupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartupPageState();
}

class StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();

    context.read<StaticDataBloc>().add(LoadStaticData());
    context.read<AuthBloc>().add(AuthStartup());
  }

  Widget _buildStartupUI(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content up a bit
              const Spacer(flex: 2),

              // App Logo with animation
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 40),

              // App Name
              Text(
                l.appTitle,
                style: textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              // Tagline or description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  l.startupTagline,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 2),

              // Loading Indicator
              Column(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.loading,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Auth listener - Load current user when authenticated
        BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is Authenticated) {
              context.read<CurrentUserBloc>().add(
                LoadCurrentUser(userId: authState.session.userId),
              );
            } else {
              context.read<CurrentUserBloc>().add(ClearCurrentUser());
            }
          },
        ),
        // StaticData listener
        BlocListener<StaticDataBloc, StaticDataState>(
          listener: (context, staticDataState) {
            final l = AppLocalizations.of(context);
            if (staticDataState is StaticDataLoaded) {
              // Navigate to home page after static data is loaded
              context.goNamed(AppRouteName.home);
            } else if (staticDataState is StaticDataError) {
              SnackBarUtils.showError(
                context,
                '${l.loadingDataError}: ${staticDataState.failure.message}',
                action: SnackBarAction(
                  label: l.tryAgain,
                  onPressed: () {
                    context.read<StaticDataBloc>().add(
                      LoadStaticData(forceRefresh: true),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
      child: _buildStartupUI(context),
    );
  }
}
