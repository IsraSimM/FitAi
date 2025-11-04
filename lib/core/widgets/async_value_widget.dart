import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freet/app/localization/app_localizations.dart';

/// Widget auxiliar para manejar estados `AsyncValue`.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.loading,
    this.error,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final WidgetBuilder? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading?.call(context) ?? const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        if (this.error != null) {
          return this.error!(error, stackTrace);
        }
        final l10n = AppLocalizations.of(context);
        return Center(child: Text(l10n.errorWithDetails(error)));
      },
    );
  }
}
