import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/favorites_bloc.dart';
import '../../../data/models/book.dart';
import '../../home/widgets/book_card.dart';
import '../../book_details/pages/book_details_page.dart';
import '../../../core/theme/app_colors.dart';

class FavoritesGrid extends StatelessWidget {
  final List<Book> books;
  final VoidCallback onRefresh;

  const FavoritesGrid({
    super.key,
    required this.books,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return FavoriteBookCard(book: book, onRefresh: onRefresh);
      },
    );
  }
}

class FavoriteBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onRefresh;

  const FavoriteBookCard({
    super.key,
    required this.book,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BookCard(
          book: book,
          isCompact: false,
          onTap: (selectedBook) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsPage(bookId: selectedBook.id),
              ),
            ).then((_) {
              onRefresh();
            });
          },
        ),
        Positioned(
          top: 8,
          right: 8,
          child: RemoveFavoriteButton(book: book, onRefresh: onRefresh),
        ),
      ],
    );
  }
}

class RemoveFavoriteButton extends StatelessWidget {
  final Book book;
  final VoidCallback onRefresh;

  const RemoveFavoriteButton({
    super.key,
    required this.book,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.close, size: 16, color: AppColors.error),
        onPressed: () async {
          context.read<FavoritesBloc>().add(RemoveFromFavorites(book.id));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.favorite_border, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${book.title} удалена из избранного')),
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

          onRefresh();
        },
      ),
    );
  }
}
