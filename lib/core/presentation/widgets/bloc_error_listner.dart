// lib/core/presentation/widgets/bloc_error_listener.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Generic error listener that shows SnackBar for any BLoC state with error
///
/// Usage:
/// ```dart
/// BlocErrorListener<AuthBloc, AuthState>(
///   child: YourWidget(),
/// )
/// ```
class BlocErrorListener<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final Widget child;
  final String Function(S state)? errorMessage;
  final bool Function(S previous, S current)? listenWhen;

  const BlocErrorListener({
    Key? key,
    required this.child,
    this.errorMessage,
    this.listenWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: listenWhen ?? (previous, current) => _hasError(current),
      listener: (context, state) {
        if (_hasError(state)) {
          final message =
              errorMessage?.call(state) ?? _extractErrorMessage(state);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'حسناً',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
        }
      },
      child: child,
    );
  }

  bool _hasError(S state) {
    // Check for common error state patterns
    if (state.toString().contains('Error') ||
        state.toString().contains('Failure')) {
      return true;
    }

    // Check if state has a 'failure' property
    try {
      final dynamic stateObj = state;
      if (stateObj is Object) {
        final type = stateObj.runtimeType.toString();
        return type.contains('Error') || type.contains('Failure');
      }
    } catch (_) {}

    return false;
  }

  String _extractErrorMessage(S state) {
    // Try to extract error message from state
    try {
      final dynamic stateObj = state;

      // Try accessing 'failure' property
      if (stateObj is Object) {
        // Use reflection-like access
        final stateMap = _toMap(stateObj);
        if (stateMap.containsKey('failure')) {
          final failure = stateMap['failure'];
          if (failure != null) {
            final failureMap = _toMap(failure);
            if (failureMap.containsKey('message')) {
              return failureMap['message']?.toString() ?? 'حدث خطأ غير متوقع';
            }
          }
        }

        // Try accessing 'message' directly
        if (stateMap.containsKey('message')) {
          return stateMap['message']?.toString() ?? 'حدث خطأ غير متوقع';
        }
      }
    } catch (_) {}

    return 'حدث خطأ غير متوقع';
  }

  Map<String, dynamic> _toMap(Object obj) {
    // Simple property extraction
    final map = <String, dynamic>{};
    try {
      final string = obj.toString();
      // Parse strings like "AuthError(failure: AuthFailure(message: ...))"
      final regex = RegExp(r'(\w+):\s*([^,)]+)');
      final matches = regex.allMatches(string);
      for (final match in matches) {
        if (match.groupCount >= 2) {
          map[match.group(1)!] = match.group(2);
        }
      }
    } catch (_) {}
    return map;
  }
}
