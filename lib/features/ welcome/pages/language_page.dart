import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/core/bloc/locale_bloc/locale_bloc.dart';
import 'package:spines/core/bloc/session/session_cubit.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/core/navigation/app_routes.dart';
import 'package:spines/core/theme/app_colors.dart';
import '../widgets/language_header.dart';
import '../widgets/language_list.dart';
import '../widgets/continue_button.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage>
    with TickerProviderStateMixin {
  String? _selectedLanguage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _loadSavedLanguage();
    });
  }

  void _loadSavedLanguage() {
    context.read<LocaleBloc>().add(LoadSavedLocale());
    final currentLocale = context.read<LocaleBloc>().state.locale;
    if (currentLocale != null) {
      setState(() {
        _selectedLanguage = S.getNameByLocale(currentLocale);
      });
    }
  }

  void _onLanguageSelected(String languageName) {
    setState(() {
      _selectedLanguage = languageName;
    });

    final locale = S.getLocaleByName(languageName);
    context.read<LocaleBloc>().add(ChangeLocale(locale));
  }

  Future<void> _onContinue() async {
    if (_selectedLanguage == null) return;

    final langCode = S.getLocaleByName(_selectedLanguage!).languageCode;
    await context.read<SessionCubit>().onLanguageSelected(langCode);

    if (mounted) {
      context.go(AppRoutes.welcome.path);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const LanguageHeader(),
              const SizedBox(height: 48),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: LanguageList(
                      selectedLanguage: _selectedLanguage,
                      onLanguageSelected: _onLanguageSelected,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ContinueButton(
                isEnabled: _selectedLanguage != null,
                onPressed: _onContinue,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
