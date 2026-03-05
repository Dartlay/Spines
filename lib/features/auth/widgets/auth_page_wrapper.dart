import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/core/navigation/app_routes.dart';
import 'package:spines/core/theme/app_colors.dart';
import 'package:spines/core/localization/s.dart';

class AuthPageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AuthPageWrapper({
    super.key,
    required this.title,
    required this.child,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  if (onBack != null) {
                    onBack!();
                  } else if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.welcome.path);
                  }
                },
              )
            : null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }
}
