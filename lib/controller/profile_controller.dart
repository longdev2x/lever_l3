import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/media_entity.dart';
import 'package:timesheet/data/model/body/role.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/profile_repo.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo repo;
  ProfileController({required this.repo});

  User? _user;
  bool _loading = false;
  bool _imgLoading = false;
  File? _fileAvatar;

  User? get user => _user;
  bool get loading => _loading;
  bool get imgLoading => _imgLoading;
  File? get fileAvatar => _fileAvatar;

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

  Future<int> uploadAvatar(XFile xFile) async {
    _imgLoading = true;
    update();

    Response response = await repo.uploadFile(xFile);

    if (response.statusCode == 200) {
      MediaEntity? objMedia = MediaEntity.fromJson(response.body);
      _user = _user!.copyWith(
        image: objMedia.name,
      );

      Response updateResponse = await repo.updateInfo(_user!);

      if (updateResponse.statusCode == 200) {
        await getImage();
      } else {
        ApiChecker.checkApi(response);
        return updateResponse.statusCode!;
      }
    } else {
      _imgLoading = false;
      update();
      ApiChecker.checkApi(response);
    }

    return response.statusCode!;
  }

  Future<void> getImage() async {
    if (_user?.image == null) {
      return;
    }

    Response response = await repo.getFile(_user!.image!);

    if (response.statusCode == 200) {
      //Tạo file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/testName');

      //Ghi dữ liệu vào file
      if (response.bodyString != null) {
        _fileAvatar = await file.writeAsBytes(response.bodyString!.codeUnits);
        print('zzzz - Ok update _fileAvatar');
      }

    } else {
      ApiChecker.checkApi(response);
    }

    _imgLoading = false;
    update();
  }
}
