import 'package:flutter/material.dart';
import 'package:spines/core/theme/app_colors.dart';

class QuestionnaireOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final bool useBoldForSelected;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const QuestionnaireOptionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.useBoldForSelected = true,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? (backgroundColor ?? AppColors.secondary)
              : (unselectedColor ?? AppColors.secondaryLight),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected && useBoldForSelected
                ? FontWeight.w600
                : FontWeight.normal,
            color: isSelected
                ? (selectedTextColor ?? AppColors.primary)
                : (unselectedTextColor ?? AppColors.textSecondary),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
