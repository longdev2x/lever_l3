import 'package:timesheet/data/model/body/user.dart';

class CommentEntity {
  final int? id;
  final String? content;
  final String? date;
  final User? user;

  CommentEntity({
    this.content,
    this.date,
    this.id,
    this.user,
  });

  factory CommentEntity.fromJson(Map<String, dynamic>? json) {
    return CommentEntity(
      content: json?['content'],
      date: json?['date'],
      id: json?['id'],
      user: User.fromJson(json?['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'id': id,
      'user': user?.toJson(),
    };
  }
}
