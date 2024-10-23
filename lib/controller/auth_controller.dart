import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/role.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/model/response/token_resposive.dart';
import 'package:timesheet/data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo repo;

  AuthController({required this.repo});

  bool _loading = false;
  User _user = User();

  bool get loading => _loading;
  User get user => _user;

  Future<int> signUp(User objUser) async {
    Role role = Role(null, 'ROLE_ADMIN', 'ROLE_ADMIN');
    objUser = objUser.copyWith(
      active: true,
      changePass: true,
      roles: [role]
    );
    _loading = true;
    update();

    Response response = await repo.signUp(objUser: objUser);
    if (response.statusCode == 200) {
      TokenResponsive tokeBody = TokenResponsive.fromJson(response.body);
      repo.saveUserToken(tokeBody.accessToken!);
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> login(String username, String password) async {
    _loading = true;
    update();
    Response response =
        await repo.login(username: username, password: password);
    if (response.statusCode == 200) {
      TokenResponsive tokeBody = TokenResponsive.fromJson(response.body);
      repo.saveUserToken(tokeBody.accessToken!);
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> logOut() async {
    _loading = true;
    Response response = await repo.logOut();
    if (response.statusCode == 200) {
      repo.clearUserToken();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> getCurrentUser() async {
    Response response = await repo.getCurrentUser();
    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  void updateUser(User userUpdate) {
    _user = userUpdate;
  }

  void clearData() {
    _loading = false;
    _user = User();
  }
}
