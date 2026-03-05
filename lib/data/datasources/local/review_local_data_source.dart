import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spines/data/models/review.dart';

class ReviewLocalDataSource {
  static const String _reviewsKey = 'book_reviews';

  Future<void> saveReview(String bookId, Review review) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allReviews = prefs.getString(_reviewsKey) ?? '{}';
      final Map<String, dynamic> reviewsMap = json.decode(allReviews);

      List<dynamic> bookReviews = reviewsMap[bookId] ?? [];
      bookReviews.add(review.toJson());
      reviewsMap[bookId] = bookReviews;

      await prefs.setString(_reviewsKey, json.encode(reviewsMap));
    } catch (e) {}
  }

  Future<List<Review>> loadReviews(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allReviews = prefs.getString(_reviewsKey) ?? '{}';
      final Map<String, dynamic> reviewsMap = json.decode(allReviews);

      final List<dynamic> bookReviews = reviewsMap[bookId] ?? [];
      return bookReviews
          .map((json) => Review.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, List<Review>>> loadAllReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allReviews = prefs.getString(_reviewsKey) ?? '{}';
      final Map<String, dynamic> reviewsMap = json.decode(allReviews);

      final result = <String, List<Review>>{};

      reviewsMap.forEach((bookId, reviewsList) {
        result[bookId] = (reviewsList as List)
            .map((json) => Review.fromJson(json as Map<String, dynamic>))
            .toList();
      });

      return result;
    } catch (e) {
      return {};
    }
  }
}
