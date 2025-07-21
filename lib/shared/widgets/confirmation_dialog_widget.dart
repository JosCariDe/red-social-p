import 'package:flutter/material.dart';
import 'package:red_social_prueba/shared/widgets/action_button_widget.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? confirmText;
  final String? cancelText;
  final String? loadingText;

  const ConfirmationDialogWidget({
    super.key,
    required this.onConfirm,
    this.onCancel,
    this.isLoading = false,
    this.title = '¿Confirmar acción?',
    this.subtitle = 'Esta acción se ejecutará inmediatamente',
    this.icon = Icons.help_outline,
    this.iconColor,
    this.backgroundColor,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? Theme.of(context).primaryColor;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: effectiveIconColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 32,
                color: effectiveIconColor,
              ),
            ),
            const SizedBox(height: 24),
            
            // Título
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Subtítulo
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            
            // Botones
            ActionButtonWidget(
              onPressed: onConfirm,
              onCancel: onCancel ?? () => Navigator.of(context).pop(),
              isLoading: isLoading,
              primaryText: confirmText,
              cancelText: cancelText,
              loadingText: loadingText,
              primaryColor: effectiveIconColor,
              showIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}