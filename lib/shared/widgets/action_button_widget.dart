import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;
  final bool isLoading;
  final String? primaryText;
  final String? cancelText;
  final String? loadingText;
  final IconData? icon;
  final Color? primaryColor;
  final Color? textColor;
  final bool showCancelButton;
  final bool showIcon;
  final double? width;
  final double? height;
  final double? borderRadius;
  final ButtonStyle? style;

  const ActionButtonWidget({
    super.key,
    required this.onPressed,
    this.onCancel,
    this.isLoading = false,
    this.primaryText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.loadingText,
    this.icon,
    this.primaryColor,
    this.textColor = Colors.white,
    this.showCancelButton = true,
    this.showIcon = true,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? Theme.of(context).primaryColor;
    final effectiveLoadingText = loadingText ?? 'Procesando...';
    
    return Column(
      children: [
        // Botón principal
        Container(
          width: width ,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius!),
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style ?? ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(textColor!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        effectiveLoadingText,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showIcon && icon != null) ...[
                        Icon(
                          icon,
                          color: textColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        primaryText!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        // Botón secundario (opcional)
        if (showCancelButton) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: width ?? double.infinity,
            height: height,
            child: OutlinedButton(
              onPressed: isLoading ? null : onCancel,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius!),
                ),
              ),
              child: Text(
                cancelText!,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}