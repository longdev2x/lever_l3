import 'package:timesheet/data/model/body/comment_entity.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/user.dart';

class PostEntity {
  final String? content;
  final DateTime? date;
  final List<dynamic> media;
  final List<LikeEntity> likes;
  final List<CommentEntity> comments;
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
      comments: json?['comments'] != null
          ? (json!['comments'] as List)
              .map((comment) => CommentEntity.fromJson(comment))
              .toList()
          : [],
      content: json?['content'],
      date: json?['date'] != null ? DateTime.fromMillisecondsSinceEpoch(json?['date']) : null,
      likes: json?['likes'] != null
          ? (json?['likes'] as List)
              .map((like) => LikeEntity.fromJson(like))
              .toList()
          : [],
      media: json?['media'] ?? [],
      user: json?['user'] != null
          ? User.fromJson(json?['user'])
          : null,
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
