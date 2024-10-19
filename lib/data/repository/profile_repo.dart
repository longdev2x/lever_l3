
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/utils/app_constants.dart';

class ProfileRepo {
  final ApiClient apiClient;

  const ProfileRepo({required this.apiClient});

  Future<Response> updateInfo(User objUser) async {
    return await apiClient.postData(
      AppConstants.UPDATE_INFO,
      objUser.toJson(),
      null,
    );
  }

  Future<Response> uploadFile(XFile xFile) async {
    return await apiClient.postMultipartData(
      AppConstants.UPLOAD_FILE,
      {},
      [MultipartBody('uploadfile', xFile)],
      headers: null,
    );
  }

  Future<Response> getFile(String nameFile) async {
    return await apiClient.getImageData(
      AppConstants.GET_FILE,
      nameFile: nameFile,
      headers: null,
    );
  }


}
