import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/comment_entity.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/media_entity.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/data/model/body/post_search_entity.dart';
import 'package:timesheet/data/model/body/request/search_request.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/post_repo.dart';

class PostController extends GetxController implements GetxService {
  final PostRepo repo;
  PostController({required this.repo});

  User? _user;
  List<PostEntity>? _posts;
  bool _isFirstLoad = true;
  bool _loading = false;
  bool _hasMoreData = true;
  List<XFile>? _mediaFiles;
  String? _filePath;
  File? _filePng;

  List<PostEntity>? get posts => _posts;
  bool get isFirstLoad => _isFirstLoad;
  bool get loading => _loading;
  bool get hasMoreData => _hasMoreData;
  List<XFile>? get xMediaFiles => _mediaFiles;
  File? get filePng => _filePng;
  String? get filePath => _filePath;

  @override
  void onInit() {
    super.onInit();
    _user = Get.find<AuthController>().user;
    getPosts(keyWord: null, pageIndex: 0, size: 300, status: null);
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

    Response response = await repo.searchNews(objSearchRequest);

    if (response.statusCode == 200) {
      PostSearchEntity objPostSearch = PostSearchEntity.fromJson(response.body);
      List<PostEntity> newPosts = objPostSearch.posts;

      newPosts.sort((a, b) {
        if (a.date == null && b.date == null) {
          return 0; // cả 2 null => bằng nhau
        } else if (a.date == null) {
          return 1; // a null , b không thì a đứng sau
        } else if (b.date == null) {
          return -1; // ngược lại b sẽ đứng sau
        } else {
          return b.date!.compareTo(a.date!); // Ngày giảm dần
        }
      });

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

  Future<int> createPost({
    required String content,
  }) async {
    List<MediaEntity>? medias;
    if (_mediaFiles != null) {
      print('zzu- 1 - start');
      MediaEntity? objMedia = await uploadImages(_mediaFiles!);
      if (objMedia != null) {
        //Để tạm thời
        medias = [objMedia];
      } else {}
      print('zzu- 2 - done upload - $medias');
      print('zzu- 3 - check name file- ${medias?[0].name}');
    }

    PostEntity objPost = PostEntity(
      id: null,
      comments: [],
      content: content,
      date: DateTime.now().toUtc(),
      likes: [],
      media: medias ?? [],
      user: _user,
    );

    _loading = true;
    update();

    Response response = await repo.createPost(objPost);

    if (response.statusCode == 200) {
      PostEntity objPost = PostEntity.fromJson(response.body['data']);
      _posts = [objPost, ...?_posts];
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<MediaEntity?> uploadImages(List<XFile> xFiles) async {
    // Thằng này trả về Media json
    Response response = await repo.uploadImages(xFiles);
    print('zzu- 1. 2 - start - ${response.body}');

    if (response.statusCode == 200) {
      if (response.body != null) {
        _filePath = response.body['name'];
        return MediaEntity.fromJson(response.body);
      }

      print('zzz -1 .3 $_filePath');
    } else {
      ApiChecker.checkApi(response);
    }

    return null;
  }

  Future<void> getImage() async {
    Response response = await repo.getImage(_filePath!);
    print('zzyy- ${response.body}');

    if (response.statusCode == 200) {
      // 2. Tạo file tạm để lưu dữ liệu
      print('zzz6');
      final tempDir =
          await getTemporaryDirectory(); // import 'package:path_provider/path_provider.dart';
      print('zzz7');
      final file = File('${tempDir.path}/testName');
      print('zzz7.8');
      // 3. Ghi dữ liệu vào file
      if (response.bodyString != null) {
        print('zzz8');
        _filePng = await file.writeAsBytes(response.bodyString!.codeUnits);
        update();

        print('zzz82');
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<int> likePost(
    final DateTime? date,
    final PostEntity? objPost,
  ) async {
    LikeEntity likeEntity = LikeEntity(
        id: null, type: 0, date: DateTime.now(), objPost: objPost, user: _user);

    bool? isLiked = objPost!.likes.any((e) => e.user?.id == _user?.id);
    if (!isLiked) {
      objPost.likes.add(LikeEntity(date: date, user: _user));
    } else {
      objPost.likes.removeWhere((e) => e.user?.id == _user?.id);
    }
    update();

    Response response = await repo.likePost(likeEntity);

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

  Future<int> sendComment(String content, PostEntity objPost) async {
    CommentEntity objComment = CommentEntity(
      content: content,
      date: DateTime.now(),
      objPost: objPost,
      user: _user,
    );

    objPost.comments.add(objComment);
    update();

    print('zzz88');
    Response response = await repo.comment(objComment);
    print('zzz89');
    if (response.statusCode != 200) {
      objPost.comments.remove(objComment);
      ApiChecker.checkApi(response);
    }

    update();
    return response.statusCode!;
  }

  Future<int> editPost(
    PostEntity objPost,
    String newContent,
  ) async {
    objPost = objPost.copyWith(content: newContent, media: [
      //Em để test ạ
      MediaEntity(
        id: 0,
        contentType: 'application/octet-stream',
        contentSize: 237056,
        name: '2024-10-29 06:24:27.664070.png',
        extension: null,
        filePath:
            'src/main/resources/uploads/images/2024-10-29 06:24:27.664070.png',
        isVideo: null,
        objPost: null,
      ),
    ]);

    Response response = await repo.editPost(objPost);

    if (response.statusCode == 200) {
      objPost = PostEntity.fromJson(response.body['data']);

      final index = _posts!.indexWhere((e) => e.id == objPost.id);
      posts![index] = objPost;

    } else {
      ApiChecker.checkApi(response);
    }

    update();
    return response.statusCode!;
  }

  void addXFile(List<XFile> xFiles) {
    _mediaFiles = xFiles;
    update();
  }

  void removeXfile() {
    _mediaFiles = null;
    update();
  }
}
