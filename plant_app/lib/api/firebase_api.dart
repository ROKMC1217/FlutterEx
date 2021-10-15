import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      print("destination!!!!!!");
      print(destination);
      print("FirebaseStorage!!!!!!");
      print(FirebaseStorage);
      print("FirebaseStorage.instance!!!!!!");
      print(FirebaseStorage.instance);
      final ref = FirebaseStorage.instance.ref(destination);
      print("ref!!!!!!");
      print(ref);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
    //1010 1010
    //1101 0110
    //32 64 = 96
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
