import 'package:timesheet/data/model/body/user.dart';

class TrackingEntity {
  int? id;
  String? content;
  DateTime? date;
  User? user;

  TrackingEntity({this.id, this.content, this.date, this.user});

  TrackingEntity copyWith({
    String? content,
    DateTime? date,
    User? user,
  }) =>
      TrackingEntity(
        id: id,
        content: content ?? this.content,
        date: date ?? this.date,
        user: user ?? this.user,
      );

  factory TrackingEntity.fromJson(Map<String, dynamic> json) => TrackingEntity(
        id: json['id'],
        content: json['content'],
        date: json['date'] != null
            ? DateTime.tryParse(json['date'])?.toLocal()
            : null,
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'date': date?.toIso8601String(),
        'user': user?.toJson(),
      };
}
