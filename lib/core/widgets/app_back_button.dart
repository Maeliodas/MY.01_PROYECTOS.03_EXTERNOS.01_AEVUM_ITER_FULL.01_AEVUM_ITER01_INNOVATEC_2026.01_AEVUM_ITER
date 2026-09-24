import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

/// Botón de regreso único para toda la aplicación.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark
        ? const Color(0xFF1B2E52)
        : const Color(0xFFE2EDFF);
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed ?? () => context.pop(),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: dark ? const Color(0xFF8FB8FF) : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
