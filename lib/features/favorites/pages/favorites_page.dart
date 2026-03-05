import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/core/localization/s.dart';
import '../bloc/favorites_bloc.dart';
import '../widgets/favorites_grid.dart';
import '../widgets/favorites_empty_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/error_view.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesView();
  }
}

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadFavorites();
  }

  void _loadFavorites() {
    if (mounted) {
      context.read<FavoritesBloc>().add(const RefreshFavorites());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadFavorites();
        },
        color: AppColors.primary,
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading &&
                state.books.isEmpty) {
              return const LoadingView();
            }

            if (state.status == FavoritesStatus.error && state.books.isEmpty) {
              return ErrorView(
                message: state.errorMessage ?? 'Error',
                onRetry: () => _loadFavorites(),
              );
            }

            if (state.books.isEmpty) {
              return const FavoritesEmptyState();
            }

            return FavoritesGrid(books: state.books, onRefresh: _loadFavorites);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
              Icons.favorite_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr.favorites,
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
      actions: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () {
              _loadFavorites();
            },
            tooltip: 'Обновить',
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
