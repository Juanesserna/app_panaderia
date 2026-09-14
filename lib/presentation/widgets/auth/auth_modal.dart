import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'auth_tab_switcher.dart';
import 'back_arrow_button.dart';
import 'brand_logo.dart';
import 'login_form.dart';
import 'register_form.dart';

/// Tarjeta de autenticación (login/registro).
///
/// Por ahora es SOLO diseño: no valida ni guarda nada, no hay backend.
/// - "INICIAR SESIÓN" → llama [onLoginSuccess] (normalmente navega al
///   AppShell/Dashboard).
/// - "CREAR CUENTA" → muestra un aviso de éxito y regresa a la pestaña de
///   login para que el usuario inicie sesión manualmente.
class AlHornoAuthModal extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final bool startInRegister;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const AlHornoAuthModal({
    super.key,
    required this.onLoginSuccess,
    this.startInRegister = false,
    this.showCloseButton = true,
    this.onClose,
  });

  @override
  State<AlHornoAuthModal> createState() => _AlHornoAuthModalState();
}

class _AlHornoAuthModalState extends State<AlHornoAuthModal>
    with SingleTickerProviderStateMixin {
  late bool isLogin;
  late final AnimationController _entryController;
  late final Animation<double> _entryFade;
  late final Animation<double> _entryScale;

  @override
  void initState() {
    super.initState();
    isLogin = !widget.startInRegister;

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _entryFade =
        CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _entryScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _goToRegister() => setState(() => isLogin = false);

  void _goToLogin() => setState(() => isLogin = true);

  void _handleRegisterSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Registro exitoso! Ahora inicia sesión.'),
      ),
    );
    _goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final width = MediaQuery.of(context).size.width;
    final modalWidth = width < 480 ? width * 0.92 : 420.0;

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Opacity(
          opacity: _entryFade.value.clamp(0.0, 1.0),
          child: Transform.scale(scale: _entryScale.value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: modalWidth,
          constraints: const BoxConstraints(maxHeight: 720),
          margin: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 6, color: colors.accent),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 28,
                        child: Stack(
                          children: [
                            if (!isLogin)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: BackArrowButton(onTap: _goToLogin),
                              ),
                            if (widget.showCloseButton)
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: widget.onClose,
                                  child: Icon(Icons.close,
                                      size: 22, color: colors.textMuted),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const BrandLogo(size: 92),
                      const SizedBox(height: 18),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: Column(
                          key: ValueKey(isLogin),
                          children: [
                            Text(
                              isLogin
                                  ? 'Bienvenido de vuelta'
                                  : 'Crear cuenta',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.authTitle
                                  .copyWith(color: colors.text),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isLogin
                                  ? 'Accede a tu cuenta para gestionar pedidos'
                                  : 'Únete a la familia Al Horno',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyRegular
                                  .copyWith(color: colors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      AuthTabSwitcher(
                        isLogin: isLogin,
                        onLoginTap: _goToLogin,
                        onRegisterTap: _goToRegister,
                      ),
                      const SizedBox(height: 22),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final offsetAnim = Tween<Offset>(
                              begin: Offset(isLogin ? -0.08 : 0.08, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                  position: offsetAnim, child: child),
                            );
                          },
                          child: isLogin
                              ? LoginForm(
                                  key: const ValueKey('login'),
                                  onGoToRegister: _goToRegister,
                                  onLoginSuccess: widget.onLoginSuccess,
                                )
                              : RegisterForm(
                                  key: const ValueKey('register'),
                                  onRegisterSuccess: _handleRegisterSuccess,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}