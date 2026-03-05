import 'package:flutter/material.dart';
import 'package:spines/core/theme/app_colors.dart';
import 'package:spines/data/models/book.dart';

class BookInfoCard extends StatelessWidget {
  final Book book;

  const BookInfoCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondaryLight.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.calendar_today_rounded,
            label: 'Год',
            value: book.publicationYear.toString(),
          ),
          _buildInfoItem(
            icon: Icons.menu_book_rounded,
            label: 'Страниц',
            value: book.pages.toString(),
          ),
          _buildInfoItem(
            icon: Icons.language_rounded,
            label: 'Язык',
            value: book.language,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textHint)),
      ],
    );
  }
}
