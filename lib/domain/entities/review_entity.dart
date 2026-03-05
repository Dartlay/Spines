import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final int likes;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.likes = 0,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userAvatar,
    rating,
    comment,
    date,
    likes,
  ];
}
