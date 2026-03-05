import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spines/core/bloc/locale_bloc/locale_bloc.dart';
import 'package:spines/core/bloc/session/session_cubit.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/core/theme/app_colors.dart';
import 'section_header.dart';
import 'language_option.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr.appLanguage,
          icon: Icons.language_rounded,
        ),
        const SizedBox(height: 16),
        const LanguageCard(),
      ],
    );
  }
}

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localeBloc = context.watch<LocaleBloc>();
    final currentLocale = localeBloc.state.locale;
    final currentLanguage = currentLocale?.languageCode == 'ru'
        ? 'Русский'
        : 'English';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          LanguageOption(
            language: 'Русский',
            flag: '🇷🇺',
            isSelected: currentLanguage == 'Русский',
            onTap: () => _changeLanguage(context, 'ru'),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.secondaryLight.withOpacity(0.3),
          ),
          LanguageOption(
            language: 'English',
            flag: '🇬🇧',
            isSelected: currentLanguage == 'English',
            onTap: () => _changeLanguage(context, 'en'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    final locale = Locale(languageCode);
    final previousLanguage = context
        .read<LocaleBloc>()
        .state
        .locale
        ?.languageCode;

    if (previousLanguage == languageCode) return;

    await context.read<SessionCubit>().onLanguageSelected(languageCode);
    context.read<LocaleBloc>().add(ChangeLocale(locale));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.textOnPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                languageCode == 'ru'
                    ? 'Язык изменен на Русский'
                    : 'Language changed to English',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
