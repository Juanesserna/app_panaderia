import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'app_bottom_sheet.dart';

/// Modelo simple de UI para una notificación. Cuando exista backend, esto
/// se moverá a domain/entities y llegará vía un usecase; por ahora vive
/// aquí como dato estático (solo diseño/funcional, sin datos reales).
class NotificationItem {
  final IconData icon;
  final Color Function(AppColors) colorOf;
  final String title;
  final String sub;
  final String time;
  const NotificationItem({
    required this.icon,
    required this.colorOf,
    required this.title,
    required this.sub,
    required this.time,
  });
}

final List<NotificationItem> kSampleNotifications = [
  NotificationItem(
    icon: Icons.shopping_bag_outlined,
    colorOf: (c) => c.success,
    title: 'Nuevo pedido recibido',
    sub: 'Pedido #P-005 de Sofía Pérez',
    time: 'Hace 5 min',
  ),
  NotificationItem(
    icon: Icons.inventory_2_outlined,
    colorOf: (c) => c.warning,
    title: 'Stock bajo',
    sub: 'Harina de trigo por debajo del mínimo',
    time: 'Hace 1 h',
  ),
  NotificationItem(
    icon: Icons.error_outline,
    colorOf: (c) => c.danger,
    title: 'Pedido cancelado',
    sub: 'Pedido #P-004 de Luis Rodríguez',
    time: 'Hace 2 h',
  ),
];

/// Abre el bottom sheet de notificaciones.
void showNotificationsSheet(BuildContext context) {
  showAppBottomSheet(
    context,
    title: 'Notificaciones',
    builder: (context) => const _NotificationsList(),
  );
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < kSampleNotifications.length; i++) ...[
          _NotificationTile(item: kSampleNotifications[i]),
          if (i < kSampleNotifications.length - 1) const AppDivider(),
        ],
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final iconColor = item.colorOf(colors);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundColor: colors.surface2, child: Icon(item.icon, size: 16, color: iconColor)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
                const SizedBox(height: 2),
                Text(item.sub, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                const SizedBox(height: 4),
                Text(item.time, style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
