// lib/core/presentation/utils/error_handler_mixin.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/errors/failures.dart';

mixin ErrorHandlerMixin<S> on BlocBase<S> {
  void handleError(Failure failure, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(failure.message)));
  }
}
