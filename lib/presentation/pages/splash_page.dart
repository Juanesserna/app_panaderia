import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/auth/brand_logo.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.25, end: 1.15).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _fade = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeIn));

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), _goToLogin);
      }
    });
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brand = AppColors.light;

    return Scaffold(
      backgroundColor: brand.bg, // blanco, siempre, sin importar el tema
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value.clamp(0.0, 1.0),
              child: Transform.scale(scale: _scale.value, child: child),
            );
          },
          child: BrandLogo(
            size: 130,
            showLabel: true,
            forceLightVariant: true,
            labelColor: brand.text,
            circleColor: brand.surface2,
          ),
        ),
      ),
    );
  }
}