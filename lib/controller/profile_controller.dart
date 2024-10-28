import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/file_entity.dart';
import 'package:timesheet/data/model/body/media_entity.dart';
import 'package:timesheet/data/model/body/role.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/profile_repo.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo repo;
  ProfileController({required this.repo});

  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _user = Get.find<AuthController>().user;
  }

  Future<int> updateInfo({
    String? username,
    bool? active,
    String? birthPlace,
    String? confirmPassword,
    String? displayName,
    DateTime? dob,
    String? tokenDevice,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? university,
    String? password,
    int? countDayCheckin,
    int? countDayTracking,
    int? year,
    List<Role>? roles,
  }) async {
    if (_user == null) {
      return Future.delayed(
        const Duration(seconds: 1),
        () => 400,
      );
    }

    _user = _user!.copyWith(
      username: username,
      active: active,
      tokenDevice: tokenDevice,
      birthPlace: birthPlace,
      confirmPassword: confirmPassword,
      countDayCheckin: countDayCheckin,
      countDayTracking: countDayTracking,
      displayName: displayName,
      dob: dob,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      image: image,
      password: password,
      roles: roles,
      university: university,
      year: year,
    );

    _loading = true;
    update();

    Response response = await repo.updateInfo(_user!);

    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      
      Get.find<AuthController>().updateUser(_user!);
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> changeAvatar(XFile xFile) async {
    Response response = await repo.uploadFile(xFile);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
    }
    MediaEntity? objPostDetail = MediaEntity.fromJson(response.body);
    String? nameFile = objPostDetail.name;
    if (nameFile == null) return 400;

    Response getFileResponse = await repo.getFile(nameFile);
    if (getFileResponse.statusCode != 200) {
      ApiChecker.checkApi(response);
      return getFileResponse.statusCode!;
    }

    FileEntity objFile = FileEntity.fromJson(getFileResponse.body);
    if (objFile.url == null) {
      return 400;
    }

    int updateInforStatuscode = await updateInfo(image: nameFile);

    return updateInforStatuscode;
  }

  Future<int> updateUserForAdmin(
    User objUser, {
    String? username,
    bool? active,
    bool? changePass,
    bool? hasPhoto,
    bool? setPassword,
    String? birthPlace,
    String? tokenDevice,
    String? confirmPassword,
    String? displayName,
    DateTime? dob,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? university,
    String? password,
    int? countDayCheckin,
    int? countDayTracking,
    int? year,
    List<Role>? roles,
  }) async {
    User oldUser = objUser;

    objUser = objUser.copyWith(
      active: active,
      changePass: changePass,
      setPassword: setPassword,
      hasPhoto: hasPhoto,
      tokenDevice: tokenDevice,
      birthPlace: birthPlace,
      confirmPassword: confirmPassword,
      countDayCheckin: countDayCheckin,
      countDayTracking: countDayTracking,
      displayName: displayName,
      dob: dob,
      email: email,
      firstName: firstName,
      gender: gender,
      image: image,
      lastName: lastName,
      password: password,
      roles: roles,
      university: university,
      username: username,
      year: year,
    );
    update();

    Response response = await repo.updateUserForAdmin(objUser);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
      objUser = oldUser;
    }

    update();

    return response.statusCode!;
  }
}
