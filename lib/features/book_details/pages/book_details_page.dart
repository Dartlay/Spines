import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/book_details_bloc.dart';
import '../widgets/book_cover_header.dart';
import '../widgets/book_stats.dart';
import '../widgets/book_info_card.dart';
import '../widgets/book_genres.dart';
import '../widgets/book_description.dart';
import '../widgets/book_action_buttons.dart';
import '../widgets/reviews_section.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/bloc/favorites_bloc.dart';
import '../../../main.dart';

class BookDetailsPage extends StatelessWidget {
  final String bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookDetailsBloc(repository: globalRepository)
            ..add(LoadBookDetails(bookId)),
      child: BookDetailsView(bookId: bookId),
    );
  }
}

class BookDetailsView extends StatefulWidget {
  final String bookId;

  const BookDetailsView({super.key, required this.bookId});

  @override
  State<BookDetailsView> createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
          if (state.status == BookDetailsStatus.loading) {
            return const LoadingView(message: 'Загрузка книги...');
          }

          if (state.status == BookDetailsStatus.error) {
            return ErrorView(
              message: state.errorMessage ?? 'Ошибка загрузки',
              onRetry: () {
                context.read<BookDetailsBloc>().add(
                  LoadBookDetails(widget.bookId),
                );
              },
            );
          }

          final book = state.book;
          if (book == null) {
            return const ErrorView(message: 'Книга не найдена');
          }

          return CustomScrollView(
            slivers: [
              BookCoverHeader(
                book: book,
                onFavoritePressed: () async {
                  context.read<BookDetailsBloc>().add(ToggleFavorite(book.id));

                  if (context.mounted) {
                    context.read<FavoritesBloc>().add(const RefreshFavorites());
                  }
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookStats(book: book),
                      const SizedBox(height: 24),
                      BookInfoCard(book: book),
                      const SizedBox(height: 24),
                      BookGenres(book: book),
                      const SizedBox(height: 24),
                      BookDescription(book: book),
                      const SizedBox(height: 24),
                      BookActionButtons(book: book, isOnShelf: state.isOnShelf),
                      const SizedBox(height: 24),
                      ReviewsSection(book: book),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
