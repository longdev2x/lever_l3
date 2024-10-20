import 'package:timesheet/data/model/body/post_entity.dart';

class PostSearchEntity {
  final List<PostEntity> posts;
  final bool? empty;
  final bool? first;
  final bool? last;
  final int? number;
  final int? numberOfElements;
  final int? size;
  final int? totalElements;
  final int? totalPages;
  final PageableEntity? objPageable;
  final SortEntity? objSort;


  const PostSearchEntity(
    this.posts,
    this.empty,
    this.first,
    this.last,
    this.number,
    this.numberOfElements,
    this.size,
    this.totalElements,
    this.totalPages,
    this.objPageable,
    this.objSort,
  );

  factory PostSearchEntity.fromJson(Map<String, dynamic>? json) =>
      PostSearchEntity(
        (json?['content'] as List<dynamic>).map((json) {
          return PostEntity.fromJson(json);
        }).toList(),
        json?['empty'],
        json?['first'],
        json?['last'],
        json?['number'],
        json?['numberOfElements'],
        json?['size'],
        json?['totalElements'],
        json?['totalPages'],
        PageableEntity.fromJson(json?['objPageable']),
        SortEntity.fromJson(json?['objSort']),
      );
}


class PageableEntity {
  final int? offset;
  final int? pageNumber;
  final int? pageSize;
  final bool? paged;
  final bool? unpaged;
  final SortEntity? objSort;

  const PageableEntity(
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
    this.objSort,
  );

  factory PageableEntity.fromJson(Map<String, dynamic>? json) => PageableEntity(
        json?['offset'],
        json?['pageNumber'],
        json?['pageSize'],
        json?['paged'],
        json?['unpaged'],
        SortEntity.fromJson(json?['objSort']),
      );
}


class SortEntity {
  final bool? empty;
  final bool? sorted;
  final bool? unsorted;

  const SortEntity(this.empty, this.sorted, this.unsorted);
  factory SortEntity.fromJson(Map<String, dynamic>? json) => SortEntity(
        json?['empty'],
        json?['sorted'],
        json?['unsorted'],
      );
}