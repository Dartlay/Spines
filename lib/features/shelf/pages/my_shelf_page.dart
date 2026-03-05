import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spines/core/localization/s.dart';
import '../bloc/shelf_bloc.dart';
import '../widgets/empty_shelf_view.dart';
import '../widgets/shelf_book_card.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../../core/theme/app_colors.dart';

class MyShelfPage extends StatelessWidget {
  const MyShelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShelfView();
  }
}

class ShelfView extends StatefulWidget {
  const ShelfView({super.key});

  @override
  State<ShelfView> createState() => _ShelfViewState();
}

class _ShelfViewState extends State<ShelfView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _loadShelf();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadShelf();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadShelf();
  }

  void _loadShelf() {
    if (mounted) {
      context.read<ShelfBloc>().add(const RefreshShelf());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          _loadShelf();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
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
              Text(
                context.tr.myShelf,
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
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  context.read<ShelfBloc>().add(const PickAndAddBook());
                },
                tooltip: context.tr.addToShelf2,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _loadShelf();
          },
          color: AppColors.primary,
          child: BlocConsumer<ShelfBloc, ShelfState>(
            listener: (context, state) {
              if (state.status == ShelfStatus.error &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(child: Text(state.errorMessage!)),
                      ],
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == ShelfStatus.loading && state.books.isEmpty) {
                return LoadingView(message: context.tr.loadingShelf);
              }

              if (state.status == ShelfStatus.error && state.books.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Error',
                  onRetry: () => _loadShelf(),
                );
              }

              if (state.books.isEmpty) {
                return const EmptyShelfView();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  final progress = book.pages > 0
                      ? book.currentPage / book.pages
                      : 0.0;

                  return ShelfBookCard(
                    book: book,
                    progress: progress,
                    onRefresh: _loadShelf,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
