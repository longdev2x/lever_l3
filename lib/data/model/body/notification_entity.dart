import 'package:timesheet/data/model/body/user.dart';

class NotificationEntity {
  final String? id;
  final String? title;
  final String? type;
  final String? body;
  final DateTime? date;
  final User? user;

  const NotificationEntity(
    this.id,
    this.title,
    this.type,
    this.body,
    this.date,
    this.user,
  );

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? type,
    String? body,
    DateTime? date,
    User? user,
  }) =>
      NotificationEntity(
        id ?? this.id,
        title ?? this.title,
        type ?? this.type,
        body ?? this.body,
        date ?? this.date,
        user ?? this.user,
      );

  factory NotificationEntity.fromJson(Map<String, dynamic>? json) =>
      NotificationEntity(
        json?['id'],
        json?['title'],
        json?['type'],
        json?['body'],
        json?['date'],
        json?['user'],
      );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'title': title,
  //       'type': type,
  //       'body': body,
  //       'date': date?.toUtc().toIso8601String(),
  //       'user': user?.toJson(),
  //     };
}
