import 'package:flutter/material.dart';
import 'package:freet/app/localization/app_localizations.dart';

/// Barra superior reutilizable con avatar, nombre y accesos a acciones globales.
class FreeTTopBar extends StatelessWidget implements PreferredSizeWidget {
  const FreeTTopBar({
    required this.username,
    this.photoUrl,
    this.onNotificationsPressed,
    this.onSettingsPressed,
    super.key,
  });

  final String username;
  final String? photoUrl;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null && username.isNotEmpty
                ? Text(username[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l10n.greeting,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  username,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onNotificationsPressed,
          tooltip: l10n.notifications,
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: onSettingsPressed,
          tooltip: l10n.settings,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
