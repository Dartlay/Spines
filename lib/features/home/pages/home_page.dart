import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/home_bloc.dart';
import '../../filters/bloc/filter_bloc.dart';
import '../widgets/home_greeting.dart';
import '../widgets/home_sections.dart';
import '../widgets/filtered_view.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/book.dart';
import '../../book_details/pages/book_details_page.dart';
import '../../favorites/bloc/favorites_bloc.dart';
import '../../shelf/bloc/shelf_bloc.dart';
import '../../../core/navigation/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _navigateToBookDetails(BuildContext context, Book book) {
    context.push('/home/book/${book.id}').then((_) {
      if (!context.mounted) return;

      context.read<HomeBloc>().add(const RefreshHomeData());
      context.read<FavoritesBloc>().add(const RefreshFavorites());
      context.read<ShelfBloc>().add(const RefreshShelf());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const RefreshHomeData());
        },
        color: AppColors.primary,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading && state.allBooks.isEmpty) {
              return const LoadingView();
            }

            if (state.status == HomeStatus.error) {
              return ErrorView(
                message: state.errorMessage ?? 'Ошибка загрузки',
                onRetry: () =>
                    context.read<HomeBloc>().add(const LoadHomeData()),
              );
            }

            final filterState = context.watch<FilterBloc>().state;

            if (filterState.hasActiveFilters && filterState.isInitialized) {
              return FilteredView(
                filterState: filterState,
                onBookTap: (book) => _navigateToBookDetails(context, book),
              );
            }

            return HomeSections(
              state: state,
              onBookTap: (book) => _navigateToBookDetails(context, book),
            );
          },
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Spines',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [HomeFilterButton(), const SizedBox(width: 8)],
    );
  }
}

class HomeFilterButton extends StatelessWidget {
  const HomeFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(Icons.filter_list_rounded, color: AppColors.primary),
        onPressed: () {
          final filterBloc = context.read<FilterBloc>();
          context.pushNamed(AppRoutes.filters.name, extra: filterBloc);
        },
      ),
    );
  }
}
