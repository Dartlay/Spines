import 'package:flutter/material.dart';
import 'package:spines/core/localization/s.dart';
import 'language_option.dart';

class LanguageList extends StatelessWidget {
  final String? selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageList({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: S.availableLanguageNames.length,
      itemBuilder: (context, index) {
        final language = S.availableLanguageNames[index];
        final isSelected = selectedLanguage == language;
        final flag = language == 'Русский' ? '🇷🇺' : '🇬🇧';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LanguageOption(
            language: language,
            flag: flag,
            isSelected: isSelected,
            onTap: () => onLanguageSelected(language),
          ),
        );
      },
    );
  }
}
