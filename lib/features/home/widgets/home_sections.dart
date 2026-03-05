import 'package:flutter/material.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/features/home/bloc/home_bloc.dart';
import '../../../data/models/book.dart';
import 'section_header.dart';
import 'book_card.dart';
import 'home_greeting.dart';

class HomeSections extends StatelessWidget {
  final HomeState state;
  final Function(Book) onBookTap;

  const HomeSections({super.key, required this.state, required this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const HomeGreeting(), const SizedBox(height: 24)],
            ),
          ),
        ),
        if (state.newBooks.isNotEmpty)
          _buildSection(title: context.tr.newBooks, books: state.newBooks),
        if (state.recommendedBooks.isNotEmpty)
          _buildSection(
            title: context.tr.recommended,
            books: state.recommendedBooks,
          ),
        if (state.popularBooks.isNotEmpty)
          _buildSection(title: context.tr.popular, books: state.popularBooks),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Book> books}) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SectionHeader(title: title),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                padding: const EdgeInsets.only(left: 20),
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: BookCard(book: books[index], onTap: onBookTap),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
