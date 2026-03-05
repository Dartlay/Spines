import 'dart:ui' as ui;
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/language_service.dart';
import '../../localization/s.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LanguageService _languageService;

  LocaleBloc(this._languageService) : super(const LocaleState(null)) {
    on<LoadSavedLocale>(_onLoadSavedLocale);
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onLoadSavedLocale(
    LoadSavedLocale event,
    Emitter<LocaleState> emit,
  ) async {
    final languageCode = await _languageService.getCurrentLanguageCode();

    final Locale locale;

    if (languageCode != null) {
      locale = S.supportedLocales.firstWhere(
        (l) => l.languageCode == languageCode,
        orElse: () => _getDefaultLocale(),
      );
    } else {
      locale = _getDefaultLocale();
    }

    emit(LocaleState(locale));
  }

  Locale _getDefaultLocale() {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    return S.supportedLocales.firstWhere(
      (l) => l.languageCode == deviceLocale.languageCode,
      orElse: () => S.supportedLocales.first,
    );
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<LocaleState> emit,
  ) async {
    await _languageService.setLanguageCode(event.locale.languageCode);
    emit(LocaleState(event.locale));
  }
}
