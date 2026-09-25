import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'al_horno_field.dart';
import 'primary_button.dart';

/// Formulario de inicio de sesión. Por ahora es solo diseño: no valida
/// contra ningún backend. Al presionar "INICIAR SESIÓN" simplemente avisa
/// que fue "exitoso" vía [onLoginSuccess] (el AuthModal decide a dónde ir).
class LoginForm extends StatefulWidget {
  final VoidCallback onGoToRegister;
  final VoidCallback onLoginSuccess;

  const LoginForm({
    super.key,
    required this.onGoToRegister,
    required this.onLoginSuccess,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Credenciales válidas mientras no haya backend real.
  static const _correoValido = 'test@gmail.com';
  static const _passwordValida = '123456';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscurePassword = true;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _intentarLogin() {
    final correo = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (correo == _correoValido && password == _passwordValida) {
      setState(() => _errorText = null);
      widget.onLoginSuccess();
    } else {
      setState(() => _errorText = 'Correo o contraseña incorrectos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AlHornoField(
          label: 'CORREO ELECTRÓNICO',
          hint: 'tu@correo.com',
          icon: Icons.mail_outline,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AlHornoField(
          label: 'CONTRASEÑA',
          hint: '••••••••',
          icon: Icons.lock_outline,
          controller: _passwordController,
          obscure: obscurePassword,
          suffix: IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 19,
              color: colors.textMuted,
            ),
            onPressed: () =>
                setState(() => obscurePassword = !obscurePassword),
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 10),
          Text(
            _errorText!,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.danger, fontSize: 13),
          ),
        ],
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {},
            child: Text(
              '¿Olvidaste tu contraseña?',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: colors.accent, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 14),
        PrimaryButton(
          label: 'INICIAR SESIÓN',
          onPressed: _intentarLogin,
        ),
        const SizedBox(height: 18),
        Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyRegular
                  .copyWith(color: colors.textMuted, fontSize: 13.5),
              children: [
                const TextSpan(text: '¿No tienes cuenta? '),
                TextSpan(
                  text: 'Regístrate',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: colors.accent,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onGoToRegister,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}