import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spines/core/bloc/session/session_cubit.dart';
import 'package:spines/features/%20welcome/pages/language_page.dart';
import 'package:spines/features/auth/screens/login_page.dart';
import 'package:spines/features/auth/screens/register_page.dart';
import 'package:spines/features/auth/screens/welcome_page.dart';
import 'package:spines/features/filters/bloc/filter_bloc.dart';
import 'package:spines/features/filters/pages/filter_page.dart';
import 'package:spines/features/profile/pages/profile_page.dart';

import 'package:spines/features/splash/splash_page.dart';
import 'package:spines/features/home/pages/home_page.dart';
import 'package:spines/features/favorites/pages/favorites_page.dart';
import 'package:spines/features/shelf/pages/my_shelf_page.dart';
import 'package:spines/features/book_details/pages/book_details_page.dart';
import 'package:spines/features/reader/pages/reader_page.dart';
import 'package:spines/features/shared/widgets/bottom_nav_bar.dart';
import 'app_routes.dart';

class AppRouter {
  final SessionCubit sessionCubit;

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
  final _favoritesNavKey = GlobalKey<NavigatorState>(
    debugLabel: 'favoritesNav',
  );
  final _shelfNavKey = GlobalKey<NavigatorState>(debugLabel: 'shelfNav');
  final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profileNav');

  late final GoRouter router;

  AppRouter({required this.sessionCubit}) {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash.path,
      refreshListenable: GoRouterRefreshStream(sessionCubit.stream),
      redirect: _redirect,
      routes: _buildRoutes(),
    );
  }

  List<RouteBase> _buildRoutes() {
    return [
      // Публичные маршруты
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.language.path,
        name: AppRoutes.language.name,
        builder: (_, __) => const LanguagePage(),
      ),
      GoRoute(
        path: AppRoutes.welcome.path,
        name: AppRoutes.welcome.name,
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.filters.path,
        name: AppRoutes.filters.name,
        pageBuilder: (context, state) {
          final filterBloc = state.extra as FilterBloc?;
          if (filterBloc == null) {
            return MaterialPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => FilterBloc(),
                child: const FilterPage(),
              ),
              fullscreenDialog: true,
            );
          }
          return MaterialPage(
            key: state.pageKey,
            child: BlocProvider.value(
              value: filterBloc,
              child: const FilterPage(),
            ),
            fullscreenDialog: true,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.home.path,
                name: AppRoutes.home.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const HomePage(),
                  );
                },
                routes: [
                  // Детали книги
                  GoRoute(
                    path: 'book/:bookId',
                    name: AppRoutes.bookDetails.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final bookId = state.pathParameters['bookId'] ?? '';
                      return MaterialPage(
                        key: state.pageKey,
                        child: BookDetailsPage(bookId: bookId),
                      );
                    },
                  ),

                  GoRoute(
                    path: 'reader/:bookId',
                    name: AppRoutes.reader.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final bookId = state.pathParameters['bookId'] ?? '';
                      return MaterialPage(
                        key: state.pageKey,
                        child: ReaderPage(bookId: bookId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Favorites branch
          StatefulShellBranch(
            navigatorKey: _favoritesNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.favorites.path,
                name: AppRoutes.favorites.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const FavoritesPage(),
                  );
                },
              ),
            ],
          ),

          // My Shelf branch
          StatefulShellBranch(
            navigatorKey: _shelfNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.myShelf.path,
                name: AppRoutes.myShelf.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const MyShelfPage(),
                  );
                },
              ),
            ],
          ),

          // Profile branch
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile.path,
                name: AppRoutes.profile.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const ProfilePage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ];
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final session = sessionCubit.state;
    final location = state.matchedLocation;

    if (session.isLoading) {
      if (location == AppRoutes.splash.path) return null;
      return AppRoutes.splash.path;
    }

    if (session.needsLanguage) {
      if (location == AppRoutes.language.path) return null;
      return AppRoutes.language.path;
    }

    if (session.needsAuth) {
      final isAuthRoute =
          location == AppRoutes.welcome.path ||
          location == AppRoutes.login.path ||
          location == AppRoutes.register.path;

      if (!isAuthRoute) {
        return AppRoutes.welcome.path;
      }
      return null;
    }

    if (session.isAuthenticated) {
      final isPublicRoute =
          location == AppRoutes.splash.path ||
          location == AppRoutes.language.path ||
          location == AppRoutes.welcome.path ||
          location == AppRoutes.login.path ||
          location == AppRoutes.register.path;

      if (isPublicRoute) {
        return AppRoutes.home.path;
      }
    }

    return null;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
