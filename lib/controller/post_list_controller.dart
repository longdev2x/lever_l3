import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/like_request.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/data/model/body/post_search_entity.dart';
import 'package:timesheet/data/model/body/search_request.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/post_repo.dart';

class PostListController extends GetxController implements GetxService {
  final PostRepo repo;
  PostListController({required this.repo});

  User? _user;
  List<PostEntity>? _posts;
  bool _isFirstLoad = true;
  bool _loading = false;
  bool _hasMoreData = true;

  List<PostEntity>? get posts => _posts;
  bool get isFirstLoad => _isFirstLoad;
  bool get loading => _loading;
  bool get hasMoreData => _hasMoreData;

  @override
  void onInit() {
    super.onInit();
    _user = Get.find<AuthController>().user;
    getPosts(keyWord: null, pageIndex: 0, size: 15, status: null);
  }

  Future<int> getPosts({
    String? keyWord,
    required int pageIndex,
    required int size,
    required int? status,
  }) async {
    SearchRequest objSearchRequest =
        SearchRequest(keyWord, pageIndex, size, status);

    if (!hasMoreData) return 400;

    _loading = true;
    update();

    Response response = await repo.searchUser(objSearchRequest);

    if (response.statusCode == 200) {
      PostSearchEntity objPostSearch = PostSearchEntity.fromJson(response.body);
      List<PostEntity> newPosts = objPostSearch.posts;
      _posts = [...?_posts, ...newPosts];
      _hasMoreData = newPosts.isNotEmpty && newPosts.length == size;
    } else {
      ApiChecker.checkApi(response);
    }

    _isFirstLoad = false;
    _loading = false;
    update();

    return response.statusCode!;
  }

  Future<int> likePost(
    final DateTime? date,
    final PostEntity? objPost,
  ) async {
    
    LikeRequest likeRequest =
        LikeRequest(objPost?.id, 0, DateTime.now(), objPost, _user);

    bool? isLiked = objPost!.likes.any((e) => e.user?.id == _user?.id);
    if (!isLiked) {
      objPost.likes
          .add(LikeEntity(date: date, id: null, type: null, user: _user));
    } else {
      objPost.likes.removeWhere((e) => e.user?.id == _user?.id);
    }
    update();

    Response response = await repo.likePost(likeRequest, objPost.id!);

    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
      //back laji
      // if (!isLiked) {
      //   objPost.likes.removeWhere((e) => e.user?.id == _user?.id);
      // } else {
      //   objPost.likes
      //       .add(LikeEntity(date: date, id: null, type: null, user: _user));
      // }
    }
    return response.statusCode!;
  }
}
