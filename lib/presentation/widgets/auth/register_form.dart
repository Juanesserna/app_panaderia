import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'al_horno_field.dart';
import 'primary_button.dart';

/// Formulario de registro. Por ahora es solo diseño: no guarda nada.
/// Al presionar "CREAR CUENTA" avisa que fue "exitoso" vía
/// [onRegisterSuccess] (el AuthModal muestra el aviso y regresa a login).
class RegisterForm extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  const RegisterForm({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nitController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AlHornoField(
          label: 'NIT / CÉDULA',
          hint: 'Número de identificación',
          icon: Icons.badge_outlined,
          controller: _nitController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        AlHornoField(
          label: 'NOMBRE COMPLETO',
          hint: 'Tu nombre',
          icon: Icons.person_outline,
          controller: _nombreController,
        ),
        const SizedBox(height: 14),
        AlHornoField(
          label: 'CORREO ELECTRÓNICO',
          hint: 'tu@correo.com',
          icon: Icons.mail_outline,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        AlHornoField(
          label: 'TELÉFONO',
          hint: '+57 300 000 0000',
          icon: Icons.call_outlined,
          controller: _telefonoController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
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
        const SizedBox(height: 14),
        AlHornoField(
          label: 'CONFIRMAR CONTRASEÑA',
          hint: '••••••••',
          icon: Icons.lock_outline,
          controller: _confirmController,
          obscure: obscureConfirm,
          suffix: IconButton(
            icon: Icon(
              obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 19,
              color: colors.textMuted,
            ),
            onPressed: () =>
                setState(() => obscureConfirm = !obscureConfirm),
          ),
        ),
        const SizedBox(height: 18),
        PrimaryButton(
          label: 'CREAR CUENTA',
          onPressed: widget.onRegisterSuccess,
        ),
      ],
    );
  }
}