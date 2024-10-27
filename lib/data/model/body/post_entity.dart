import 'package:timesheet/data/model/body/comment_entity.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/media_entity.dart';
import 'package:timesheet/data/model/body/user.dart';

class PostEntity {
  final int? id;
  final String? content;
  final DateTime? date;
  final List<MediaEntity> media;
  final List<LikeEntity> likes;
  final List<CommentEntity> comments;
  final User? user;

  PostEntity({
    required this.id,
    required this.comments,
    required this.content,
    required this.date,
    required this.likes,
    required this.media,
    required this.user,
  });

  factory PostEntity.fromJson(Map<String, dynamic>? json) {
    return PostEntity(
      id: json?['id'],
      comments: json?['comments'] != null
          ? (json!['comments'] as List)
              .map((comment) => CommentEntity.fromJson(comment))
              .toList()
          : [],
      content: json?['content'],
      date: json?['date'] != null
          ? _convertDateFromTimestamp(json!['date'])
          : null,
      likes: json?['likes'] != null
          ? (json?['likes'] as List)
              .map((like) => LikeEntity.fromJson(like))
              .toList()
          : [],
      media: json?['media'] != null ? (json!['media'] as List).map((e) => MediaEntity.fromJson(e)).toList() : [],
      user: json?['user'] != null ? User.fromJson(json?['user']) : null,
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'content': content,
      'date': date?.toIso8601String(),
      'likes': likes.map((like) => like.toJson()).toList(),
      'media': media.map((e) => e.toJson()).toList(),
      'user': user?.toJson(),
    };
  }

  static DateTime _convertDateFromTimestamp(int timestamp) {
  
  if (timestamp.toString().length == 10) {
    timestamp *= 1000;
  }  
  return DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  }
}


// {
//   "date": "2024-10-20T01:28:40.502Z",
//   "id": 0,
//   "post": {
//     "comments": [
//       {
//         "content": "string",
//         "date": "2024-10-20T01:28:40.502Z",
//         "id": 0,
//         "user": {}
//       }
//     ],
//     "content": "string",
//     "date": "2024-10-20T01:28:40.502Z",
//     "id": 0,
//     "likes": [
//       null
//     ],
//     "media": [],
//     "user": {}
//   },
//   "type": 0,
//   "user": {}
// }
