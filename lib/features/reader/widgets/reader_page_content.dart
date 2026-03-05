import 'package:flutter/material.dart';
import 'package:spines/core/theme/app_colors.dart';

class ReaderPageContent extends StatelessWidget {
  final String text;
  final int pageNumber;
  final int totalPages;
  final double fontSize;
  final bool showSwipeHint;

  const ReaderPageContent({
    super.key,
    required this.text,
    required this.pageNumber,
    required this.totalPages,
    required this.fontSize,
    this.showSwipeHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      color: const Color(0xFFFDFAF7),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildText(),
            const SizedBox(height: 48),
            _buildFooter(),
            if (showSwipeHint) ...[
              const SizedBox(height: 40),
              _buildSwipeHint(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Container(
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.5 * value),
                      AppColors.primary,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 14,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                'Стр. $pageNumber',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        _formatText(text),
        style: TextStyle(
          fontSize: fontSize,
          height: 1.8,
          color: const Color(0xFF2C3E50),
          fontFamily: 'Georgia',
          letterSpacing: 0.3,
          wordSpacing: 0.5,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pageNumber.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.circle,
                size: 4,
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),

            Text(
              totalPages.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeHint() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: (1 - value).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnimatedSwipeIcon(),
              const SizedBox(width: 12),
              const Text(
                'Листайте свайпом',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSwipeIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-5 * value, 0),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                Transform.scale(
                  scaleX: -1,
                  child: Icon(
                    Icons.chevron_left,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatText(String text) {
    return text
        .replaceFirst(RegExp(r'Страница \d+\n\n'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}
