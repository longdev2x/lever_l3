import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/model/body/user_search_entity.dart';
import 'package:timesheet/data/model/body/request/search_request.dart';
import 'package:timesheet/data/repository/user_search_repo.dart';

class UserController extends GetxController implements GetxService {
  final UserSearchRepo repo;
  UserController({required this.repo});

  List<User>? _users;
  List<User> _userSearchs = [];
  bool _hasSearchError = false;
  bool _isFirstLoad = true;
  bool _loading = false;
  bool _hasMoreData = true;
  final Map<String, File> _mapFileAvatar = {};

  List<User>? get users => _users;
  List<User>? get userSearchs => _userSearchs;
  bool get hasSearchError => _hasSearchError;
  bool get isFirstLoad => _isFirstLoad;
  bool get loading => _loading;
  bool get hasMoreData => _hasMoreData;
  Map<String, File> get mapFileAvatar => _mapFileAvatar;

  @override
  void onReady() {
    super.onReady();
    searchUser(keyWord: null, pageIndex: 1, size: 15, status: null);
  }

  @override
  void onClose() {
    _mapFileAvatar.forEach((key, file) async {
      if (await file.exists()) {
        await file.delete();
      }
    });
    super.onClose();
  }

  Future<int> refreshData() async {
    _users?.clear();
    int statusCode =
        await searchUser(keyWord: null, pageIndex: 1, size: 15, status: null);
    return statusCode;
  }

  Future<int> searchUser({
    String? keyWord,
    required int pageIndex,
    required int size,
    required int? status,
  }) async {
    _userSearchs = [];
    _hasSearchError = false;
    SearchRequest objSearchRequest = SearchRequest(
      keyWord,
      pageIndex,
      size,
      status,
    );

    if (!hasMoreData && keyWord == null) return 400;

    _loading = true;
    update();

    Response response = await repo.searchUser(objSearchRequest);

    if (response.statusCode == 200) {
      UserSearchEntity objUserSearch = UserSearchEntity.fromJson(response.body);
      List<User> newUsers = objUserSearch.content;

      //Get avatar
      for (User objUser in newUsers) {
        if (objUser.image != null &&
            !_mapFileAvatar.containsKey(objUser.image)) {
          await getImage(objUser.image!);
        }
      }

      if (keyWord == null) {
        _users = [...?_users, ...newUsers];
        _hasMoreData = newUsers.isNotEmpty && newUsers.length == size;
      } else {
        _userSearchs = newUsers;
      }
    } else {
      _hasSearchError = true;
      ApiChecker.checkApi(response);
    }

    _isFirstLoad = false;
    _loading = false;
    update();

    return response.statusCode!;
  }

  Future<void> getImage(String nameFile) async {
    Response response = await repo.getImage(nameFile);

    if (response.statusCode == 200) {
      final Directory tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$nameFile');

      if (response.bodyString != null) {
        file = await file.writeAsBytes(response.bodyString!.codeUnits);
        _mapFileAvatar[nameFile] = file;
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }
}
