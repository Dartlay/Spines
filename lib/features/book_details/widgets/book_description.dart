import 'package:flutter/material.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/core/theme/app_colors.dart';
import 'package:spines/data/models/book.dart';

class BookDescription extends StatefulWidget {
  final Book book;

  const BookDescription({super.key, required this.book});

  @override
  State<BookDescription> createState() => _BookDescriptionState();
}

class _BookDescriptionState extends State<BookDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.description,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.secondaryLight.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                widget.book.description,
                maxLines: _isExpanded ? null : 5,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1.6,
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              if (widget.book.description.length > 200)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: Text(
                      _isExpanded ? 'Свернуть' : 'Читать полностью',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
