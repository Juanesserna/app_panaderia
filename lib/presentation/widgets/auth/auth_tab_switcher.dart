import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Selector INICIAR SESIÓN / REGISTRARSE con un indicador que se desliza.
class AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabSwitcher({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.mutedBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment:
                isLogin ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.sidebar,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLoginTap,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: AppTextStyles.captionBold.copyWith(
                        letterSpacing: 0.4,
                        color: isLogin ? colors.sidebarFg : colors.text,
                      ),
                      child: const Text('INICIAR SESIÓN'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onRegisterTap,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: AppTextStyles.captionBold.copyWith(
                        letterSpacing: 0.4,
                        color: !isLogin ? colors.sidebarFg : colors.text,
                      ),
                      child: const Text('REGISTRARSE'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}