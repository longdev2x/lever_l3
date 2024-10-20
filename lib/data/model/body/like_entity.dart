import 'package:timesheet/data/model/body/user.dart';

class LikeEntity {
  final DateTime? date;
  final int? id;
  final int? type;
  final User? user;

  LikeEntity({
    required this.date,
    required this.id,
    required this.type,
    required this.user,
  });

  factory LikeEntity.fromJson(Map<String, dynamic>? json) {
    return LikeEntity(
      id: json?['id'],
      date: json?['date'] != null ? DateTime.fromMillisecondsSinceEpoch(json?['date']) : null,
      type: json?['type'],
      user: User.fromJson(json?['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'id': id,
      'type': type,
      'user': user?.toJson(),
    };
  }
}
