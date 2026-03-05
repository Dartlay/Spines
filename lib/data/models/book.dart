import 'package:equatable/equatable.dart';
import 'review.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final String description;
  final double rating;
  final int pages;
  final int currentPage;
  final bool isFavorite;
  final String? filePath;
  final List<String> genres;
  final int publicationYear;
  final String language;
  final List<Review> reviews;
  final int viewsCount;
  final int downloadsCount;
  final bool isNew;
  final bool isBestseller;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.description,
    required this.rating,
    required this.pages,
    this.currentPage = 0,
    this.isFavorite = false,
    this.filePath,
    this.genres = const [],
    required this.publicationYear,
    this.language = 'Русский',
    this.reviews = const [],
    this.viewsCount = 0,
    this.downloadsCount = 0,
    this.isNew = false,
    this.isBestseller = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['coverUrl'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      pages: json['pages'],
      currentPage: json['currentPage'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      filePath: json['filePath'],
      genres: List<String>.from(json['genres'] ?? []),
      publicationYear: json['publicationYear'],
      language: json['language'] ?? 'Русский',
      reviews: (json['reviews'] as List? ?? [])
          .map((r) => Review.fromJson(r))
          .toList(),
      viewsCount: json['viewsCount'] ?? 0,
      downloadsCount: json['downloadsCount'] ?? 0,
      isNew: json['isNew'] ?? false,
      isBestseller: json['isBestseller'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
      'description': description,
      'rating': rating,
      'pages': pages,
      'currentPage': currentPage,
      'isFavorite': isFavorite,
      'filePath': filePath,
      'genres': genres,
      'publicationYear': publicationYear,
      'language': language,
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'viewsCount': viewsCount,
      'downloadsCount': downloadsCount,
      'isNew': isNew,
      'isBestseller': isBestseller,
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? coverUrl,
    String? description,
    double? rating,
    int? pages,
    int? currentPage,
    bool? isFavorite,
    String? filePath,
    List<String>? genres,
    int? publicationYear,
    String? language,
    List<Review>? reviews,
    int? viewsCount,
    int? downloadsCount,
    bool? isNew,
    bool? isBestseller,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      isFavorite: isFavorite ?? this.isFavorite,
      filePath: filePath ?? this.filePath,
      genres: genres ?? this.genres,
      publicationYear: publicationYear ?? this.publicationYear,
      language: language ?? this.language,
      reviews: reviews ?? this.reviews,
      viewsCount: viewsCount ?? this.viewsCount,
      downloadsCount: downloadsCount ?? this.downloadsCount,
      isNew: isNew ?? this.isNew,
      isBestseller: isBestseller ?? this.isBestseller,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    coverUrl,
    description,
    rating,
    pages,
    currentPage,
    isFavorite,
    filePath,
    genres,
    publicationYear,
    language,
    reviews,
    viewsCount,
    downloadsCount,
    isNew,
    isBestseller,
  ];
}
