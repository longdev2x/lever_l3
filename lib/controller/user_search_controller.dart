import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/model/body/user_search_entity.dart';
import 'package:timesheet/data/model/body/user_search_request.dart';
import 'package:timesheet/data/repository/user_search_repo.dart';

class UserSearchController extends GetxController {
  final UserSearchRepo repo;
  UserSearchController({required this.repo});

  List<User>? _users;
  bool _isFirstLoad = true;
  bool _loading = false;
  bool _hasMoreData = true;

  List<User>? get users => _users;
  bool get isFirstLoad => _isFirstLoad;
  bool get loading => _loading;
  bool get hasMoreData => _hasMoreData;

  @override
  void onInit() {
    super.onInit();
    searchUser(keyWord: null, pageIndex: 0, size: 15, status: null);
  }

  Future<int> searchUser({
    String? keyWord,
    required int pageIndex,
    required int size,
    required int? status,
  }) async {
    UserSearchRequest objSearchRequest =
        UserSearchRequest(keyWord, pageIndex, size, status);

    if (!hasMoreData) return 400;

    _loading = true;
    update();

    Response response = await repo.searchUser(objSearchRequest);

    if (response.statusCode == 200) {
      UserSearchEntity objUserSearch = UserSearchEntity.fromJson(response.body);
      List<User> newUsers = objUserSearch.content;
      _users = [...?_users, ...newUsers];
      _hasMoreData = newUsers.isNotEmpty && newUsers.length == size;
    } else {
      ApiChecker.checkApi(response);
    }

    _isFirstLoad = false;
    _loading = false;
    update();

    return response.statusCode!;
  }
}
