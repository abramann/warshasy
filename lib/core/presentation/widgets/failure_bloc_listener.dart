import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Specific error listener for states with Failure objects
class FailureBlocListener<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final Widget child;
  final dynamic Function(S state) getFailure;

  const FailureBlocListener({
    Key? key,
    required this.child,
    required this.getFailure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) {
        try {
          return getFailure(current) != null;
        } catch (_) {
          return false;
        }
      },
      listener: (context, state) {
        try {
          final failure = getFailure(state);
          if (failure != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(failure.toString()),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        } catch (_) {}
      },
      child: child,
    );
  }
}
