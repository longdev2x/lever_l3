import 'package:timesheet/data/model/body/post_entity.dart';

class PostDetailEntity {
  final int? id;
  final int? contentSize;
  final String? contentType;
  final String? extension;
  final String? filePath;
  final bool? isVideo;
  final String? name;
  final PostEntity? objPost;

  PostDetailEntity({
    this.contentSize,
    this.contentType,
    this.extension,
    this.filePath,
    this.id,
    this.isVideo,
    this.name,
    this.objPost,
  });

  factory PostDetailEntity.fromJson(Map<String, dynamic>? json) {
    return PostDetailEntity(
      id: json?['id'],
      contentType: json?['contentType'],
      contentSize: json?['contentSize'],
      name: json?['name'],
      extension: json?['extension'],
      filePath: json?['filePath'],
      isVideo: json?['isVideo'],
      objPost: PostEntity.fromJson(json?['posts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentSize': contentSize,
      'contentType': contentType,
      'extension': extension,
      'filePath': filePath,
      'id': id,
      'isVideo': isVideo,
      'name': name,
    };
  }
}
