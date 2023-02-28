import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageHelper {
  static StorageHelper storageHelper = StorageHelper();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<String> uplodeimage(File file) async {
    // اسم الصورة
    String filename = file.path.split("/").last;
    // اسم المجلد
    Reference reference = firebaseStorage.ref("image/$filename");
    // رفع الصورة
    TaskSnapshot taskSnapshot = await reference.putFile(file);

    String imageUri = await reference.getDownloadURL();
    return imageUri;
  }
}
