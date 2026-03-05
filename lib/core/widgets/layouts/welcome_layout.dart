import 'package:flutter/material.dart';
import 'package:spines/core/theme/app_colors.dart';
import '../buttons/primary_button.dart';

class WelcomeLayout extends StatelessWidget {
  final String titleText;
  final String descriptionText;
  final bool showBackButton;
  final bool showBackgroundImage;
  final String bottomButtonText;
  final VoidCallback? onBottomButtonPressed;
  final Widget child;
  final Color? backgroundColor;

  const WelcomeLayout({
    super.key,
    required this.titleText,
    required this.descriptionText,
    required this.showBackButton,
    required this.showBackgroundImage,
    required this.bottomButtonText,
    required this.onBottomButtonPressed,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                  Expanded(
                    child: Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: -0.9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (showBackButton) const SizedBox(width: 48),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                descriptionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: child,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: bottomButtonText,
                onPressed: onBottomButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
