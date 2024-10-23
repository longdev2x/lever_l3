import 'package:timesheet/data/model/body/post_entity.dart';

class MediaEntity {
  final int? id;
  final String? contentType;
  final int? contentSize;
  final String? extension;
  final String? filePath;
  final bool? isVideo;
  final String? name;
  final PostEntity? objPost;

  MediaEntity({
    this.contentSize,
    this.contentType,
    this.extension,
    this.filePath,
    this.id,
    this.isVideo,
    this.name,
    this.objPost,
  });

  factory MediaEntity.fromJson(Map<String, dynamic>? json) {
    return MediaEntity(
      id: json?['id'],
      contentType: json?['contentType'],
      contentSize: json?['contentSize'],
      name: json?['name'],
      extension: json?['extension'],
      filePath: json?['filePath'],
      isVideo: json?['isVideo'],
      objPost: json?['posts'] != null ? PostEntity.fromJson(json!['posts']) : null,
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