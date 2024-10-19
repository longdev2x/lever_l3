class FileEntity {
  final String? filename;
  final String? description;
  final String? url;
  final String? uri;
  final bool? open;
  final bool? readable;
  final Map<dynamic, dynamic>? inputStream;

  const FileEntity(
    this.filename,
    this.description,
    this.url,
    this.uri,
    this.open,
    this.readable,
    this.inputStream,
  );

  factory FileEntity.fromJson(Map<String, dynamic>? json) => FileEntity(
        json?['filename'],
        json?['description'],
        json?['url'],
        json?['uri'],
        json?['open'],
        json?['readable'],
        json?['inputStream'],
      );
}
