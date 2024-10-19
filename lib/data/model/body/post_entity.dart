import 'package:timesheet/data/model/body/comment_entity.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/user.dart';

class PostEntity {
  final List<CommentEntity> comments;
  final String? content;
  final String? date;
  final List<LikeEntity> likes;
  final List<dynamic> media;
  final User? user;

  PostEntity({
    required this.comments,
    required this.content,
    required this.date,
    required this.likes,
    required this.media,
    required this.user,
  });

  factory PostEntity.fromJson(Map<String, dynamic>? json) {
    return PostEntity(
      comments: json?['posts'] != null
          ? (json!['posts']['comments'] as List)
              .map((comment) => CommentEntity.fromJson(comment))
              .toList()
          : [],
      content: json?['posts']['content'],
      date: json?['posts']['date'],
      likes: json?['posts'] != null
          ? (json?['posts']['likes'] as List)
              .map((like) => LikeEntity.fromJson(like))
              .toList()
          : [],
      media: json?['posts']['media'] ?? [],
      user: json?['posts']['user'] != null ? User.fromJson(json?['posts']['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': {
        'comments': comments.map((comment) => comment.toJson()).toList(),
        'content': content,
        'date': date,
        'likes': likes.map((like) => like.toJson()).toList(),
        'media': media,
        'user': user?.toJson(),
      },
    };
  }
}
