import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/comment_entity.dart';
import 'package:timesheet/data/model/body/like_entity.dart';
import 'package:timesheet/data/model/body/post_entity.dart';
import 'package:timesheet/data/model/body/request/search_request.dart';
import 'package:timesheet/utils/app_constants.dart';

class PostRepo extends GetxService {
  final ApiClient apiClient;

  PostRepo({required this.apiClient});

  Future<Response> searchNews(SearchRequest objUserSearchRequest) async {
    return await apiClient.postData(
      AppConstants.GET_NEWS,
      objUserSearchRequest.toJson(),
      null,
    );
  }

  Future<Response> createPost(PostEntity objPost) async {
    return await apiClient.postData(
      AppConstants.CREATE_POST,
      objPost.toJson(),
      null,
    );
  }

  Future<Response> uploadImages(XFile xFile) async {
    List<MultipartBody> multipartBodys = [MultipartBody('uploadfile', xFile)];
    return await apiClient.postMultipartData(
      AppConstants.UPLOAD_FILE,
      {},
      multipartBodys,
      headers: null,
    );
  }

  Future<Response> getImage(String nameFile) async {
    return await apiClient.getImageData(
      AppConstants.GET_FILE,
      nameFile: nameFile,
    );
  }

  Future<Response> likePost(LikeEntity objLike) async {
    return await apiClient.postData(
      AppConstants.LIKE_POST,
      objLike.toJson(),
      null,
      id: objLike.objPost?.id,
    );
  }

  Future<Response> comment(CommentEntity objComment) async {
    return await apiClient.postData(
        AppConstants.SEND_COMMENT, objComment.toJson(), null,
        id: objComment.objPost?.id);
  }

  Future<Response> editPost(PostEntity objPost) async {
    return await apiClient.postData(
      AppConstants.EDIT_POST,
      objPost.toJson(),
      null,
      id: objPost.id,
    );
  }
}
