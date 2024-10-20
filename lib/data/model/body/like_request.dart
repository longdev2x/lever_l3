import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/data/model/body/user.dart';

class LikeRequest {
  final int? id;
  final int? type;
  final DateTime? date;
  final PostEntity? objPost;
  final User? objUser;
  const LikeRequest(
    this.id,
    this.type,
    this.date,
    this.objPost,
    this.objUser,
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "post": objPost?.toJson(),
        "type": type,
        "user": objUser?.toJson(),
      };
}
