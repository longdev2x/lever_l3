import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/data/model/body/user.dart';

class CommentEntity {
  final int? id;
  final String? content;
  final DateTime? date;
  final User? user;
  final PostEntity? objPost;

  CommentEntity({
    this.content,
    this.date,
    this.id,
    this.user,
    this.objPost,
  });

  factory CommentEntity.fromJson(Map<String, dynamic>? json) {
    return CommentEntity(
      content: json?['content'],
      date: json?['date'] != null ? DateTime.fromMillisecondsSinceEpoch(json?['date']) : null,
      id: json?['id'],
      user: User.fromJson(json?['user']),
      objPost: PostEntity.fromJson(json?['post']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date?.toUtc().toIso8601String(),
      'id': id,
      'user': user?.toJson(),
      //Lặp vô tận
      "post": null,
    };
  }
}


