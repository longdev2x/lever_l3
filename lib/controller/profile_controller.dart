import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/file_entity.dart';
import 'package:timesheet/data/model/body/post_detail_entity.dart';
import 'package:timesheet/data/model/body/role.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/data/repository/profile_repo.dart';

class ProfileController extends GetxController implements GetxService  {
  final ProfileRepo repo;
  ProfileController({required this.repo});

  User? _user;
  User? get user => _user;

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
    Role? roles,
  }) async {
    if(_user == null) return Future.delayed(const Duration(seconds: 1), () => 400,);

    _user = _user!.copyWith(
      username: username,
      active: active,
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

    update();

    Response response = await repo.updateInfo(_user!);
    if(response.statusCode != 200) {
      ApiChecker.checkApi(response);
    }

    Get.find<AuthController>().updateUser(_user!);
    return response.statusCode!;
  }


  Future<int> changeAvatar(XFile xFile) async {
    Response response = await repo.uploadFile(xFile);
    if(response.statusCode != 200) {
      ApiChecker.checkApi(response);
    }
    PostDetailEntity? objPostDetail = PostDetailEntity.fromJson(response.body);
    String? nameFile = objPostDetail.name;
    if(nameFile == null) return 400;

    Response getFileResponse = await repo.getFile(nameFile);
    if(getFileResponse.statusCode != 200) {
      ApiChecker.checkApi(response);
      return getFileResponse.statusCode!;
    }

    FileEntity objFile = FileEntity.fromJson(getFileResponse.body);
    if(objFile.url == null) {
      return 400;
    }

    int updateInforStatuscode = await updateInfo(image: nameFile);

    return updateInforStatuscode;
  }
}
