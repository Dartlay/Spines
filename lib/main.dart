import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bloc/locale_bloc/locale_bloc.dart';
import 'core/bloc/session/session_cubit.dart';
import 'core/localization/s.dart';
import 'core/navigation/app_router.dart';
import 'core/services/language_service.dart';
import 'core/theme/app_colors.dart';
import 'firebase_options.dart';
import 'data/datasources/local/book_local_data_source.dart';
import 'data/datasources/local/favorites_local_data_source.dart';
import 'data/datasources/local/shelf_local_data_source.dart';
import 'data/datasources/local/review_local_data_source.dart';
import 'domain/repositories/book_repository_impl.dart';
import 'features/favorites/bloc/favorites_bloc.dart';
import 'features/shelf/bloc/shelf_bloc.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/filters/bloc/filter_bloc.dart';

late BookLocalDataSource globalBookDataSource;
late FavoritesLocalDataSource globalFavoritesDataSource;
late ShelfLocalDataSource globalShelfDataSource;
late ReviewLocalDataSource globalReviewDataSource;
late BookRepositoryImpl globalRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  globalBookDataSource = BookLocalDataSource();
  globalFavoritesDataSource = FavoritesLocalDataSource();
  globalShelfDataSource = ShelfLocalDataSource();
  globalReviewDataSource = ReviewLocalDataSource();

  // Загружаем книги при старте
  await globalBookDataSource.getBooks();

  // Создаем глобальный репозиторий
  globalRepository = BookRepositoryImpl(
    bookDataSource: globalBookDataSource,
    favoritesDataSource: globalFavoritesDataSource,
    shelfDataSource: globalShelfDataSource,
    reviewDataSource: globalReviewDataSource,
  );

  final sessionCubit = SessionCubit();

  runApp(MyApp(sessionCubit: sessionCubit, repository: globalRepository));
}

class MyApp extends StatelessWidget {
  final SessionCubit sessionCubit;
  final BookRepositoryImpl repository;

  const MyApp({
    super.key,
    required this.sessionCubit,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: sessionCubit),
        BlocProvider<LocaleBloc>(
          create: (context) => LocaleBloc(LanguageService()),
        ),
        BlocProvider<FilterBloc>(create: (context) => FilterBloc()),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            repository: repository,
            filterBloc: context.read<FilterBloc>(),
          )..add(const LoadHomeData()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) =>
              FavoritesBloc(repository: repository)..add(const LoadFavorites()),
        ),
        BlocProvider<ShelfBloc>(
          create: (context) =>
              ShelfBloc(repository: repository)..add(const LoadShelf()),
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          final router = AppRouter(sessionCubit: sessionCubit).router;

          return MaterialApp.router(
            title: 'Spines',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            locale: localeState.locale,
            supportedLocales: S.supportedLocales,
            localizationsDelegates: S.localizationsDelegates,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme.light(primary: AppColors.primary),
              scaffoldBackgroundColor: AppColors.background,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }
}
