import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';


// Firebase Storage đang không cho quyền
class FirebaseStorageRepo {
  static final FirebaseStorage _instance = FirebaseStorage.instance;

  static Future<String?> uploadImage(File file) async {
    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    try {
      Reference ref = _instance.ref().child('images/$fileName');
      await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('zzzError upload file - $e');
    }
    return null;
  }
}
