import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifications = <_NotificationItem>[
      _NotificationItem(
        title: l10n.notificationsSampleRoutineTitle,
        body: l10n.notificationsSampleRoutineBody,
        type: l10n.notificationsSampleRoutineType,
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      _NotificationItem(
        title: l10n.notificationsSampleSocialTitle,
        body: l10n.notificationsSampleSocialBody,
        type: l10n.notificationsSampleSocialType,
        timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 20)),
      ),
      _NotificationItem(
        title: l10n.notificationsSampleHealthTitle,
        body: l10n.notificationsSampleHealthBody,
        type: l10n.notificationsSampleHealthType,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              Container(
                width: 56,
                height: 6,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              ListTile(
                title: Text(
                  l10n.notifications,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: Text(l10n.commonConfigure),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          item.type.isNotEmpty ? item.type[0].toUpperCase() : '?',
                        ),
                      ),
                      title: Text(item.title),
                      subtitle: Text(
                        '${item.body}\n${_relativeTime(l10n, item.timestamp)}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _relativeTime(AppLocalizations l10n, DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${l10n.timeMinuteShort}';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} ${l10n.timeHourShort}';
    }
    return '${difference.inDays} ${l10n.timeDayShort}';
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
  });

  final String title;
  final String body;
  final String type;
  final DateTime timestamp;
}
