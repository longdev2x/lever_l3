import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/data/model/body/post_search_entity.dart';
import 'package:timesheet/data/model/body/search_request.dart';
import 'package:timesheet/data/repository/post_repo.dart';

class PostListController extends GetxController implements GetxService {
  final PostRepo repo;
  PostListController({required this.repo});

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
}
