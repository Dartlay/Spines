import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  final String name;
  final String? _segment;
  final AppRoute? parent;

  const AppRoute(this.name, {String? segment, this.parent})
    : _segment = segment;

  String get segment => _segment ?? name;
  String get path => parent == null ? '/$segment' : '${parent!.path}/$segment';
  String get relativePath => segment;
}

abstract class AppRoutes {
  // Публичные маршруты
  static const splash = AppRoute('splash');
  static const language = AppRoute('language');
  static const welcome = AppRoute('welcome');
  static const login = AppRoute('login');
  static const register = AppRoute('register');

  // Защищенные маршруты (с нижним меню)
  static const home = AppRoute('home');
  static const favorites = AppRoute('favorites');
  static const myShelf = AppRoute('my-shelf');
  static const profile = AppRoute('profile');
  static const bookDetails = AppRoute('book-details');
  static const reader = AppRoute('reader');
  static const filters = AppRoute('filters');
}

extension AppRouterHelper on BuildContext {
  void goToSplash() => go(AppRoutes.splash.path);
  void goToLanguage() => go(AppRoutes.language.path);
  void goToWelcome() => go(AppRoutes.welcome.path);
  void goToLogin() => go(AppRoutes.login.path);
  void goToRegister() => go(AppRoutes.register.path);
  void goToHome() => go(AppRoutes.home.path);
  void goToFavorites() => go(AppRoutes.favorites.path);
  void goToMyShelf() => go(AppRoutes.myShelf.path);
  void goToProfile() => go(AppRoutes.profile.path);
  void goToFilters() => push(AppRoutes.filters.path);
  void pushToLanguage() => push(AppRoutes.language.path);
  void pushToWelcome() => push(AppRoutes.welcome.path);
  void pushToLogin() => push(AppRoutes.login.path);
  void pushToRegister() => push(AppRoutes.register.path);
  void pushToHome() => push(AppRoutes.home.path);
  void pushToFavorites() => push(AppRoutes.favorites.path);
  void pushToMyShelf() => push(AppRoutes.myShelf.path);
  void pushToProfile() => push(AppRoutes.profile.path);
  void goToBookDetails(String bookId) => go('/home/book/$bookId');
  void goToReader(String bookId) => go('/home/reader/$bookId');

  void pushToBookDetails(String bookId) => push('/home/book/$bookId');
  void pushToReader(String bookId) => push('/home/reader/$bookId');

  void maybePop([dynamic result]) => canPop() ? pop(result) : null;
}
