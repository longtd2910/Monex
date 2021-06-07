import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monex/Components/ErrorCode.dart';
import 'package:monex/Components/Transaction.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum SignInType {
  Common,
  Facebook,
  Google,
}

enum Gender {
  Male,
  Female,
  Other,
}

class User {
  String? firstName;
  String? lastName;
  String userId;
  double? balance;
  List<SignInType> signInType;
  List<Transaction>? lstTransaction;
  String? email;
  Gender? gender;
  String? avatarLink;
  String? avatarLocalPath;
  User(this.userId, this.signInType);
  ActionStatus? localAvatarReady;

  Future<bool> updateAvatarFromServer() async {
    this.localAvatarReady = ActionStatus.Waiting;
    var response = await http.get(Uri.parse(avatarLink!));
    var filePath = await getLocalAvatarPath();
    File image = new File(filePath);
    await image.create(recursive: true);
    avatarLocalPath = filePath;
    await image.writeAsBytes(response.bodyBytes);
    return true;
  }

  Future<String> getLocalAvatarPath() async {
    var getDirectory = await getApplicationDocumentsDirectory();
    var folderPath = getDirectory.path;
    await Directory(folderPath).create(recursive: true);
    return folderPath + "/images/$userId.png";
  }

  Future<bool> uploadToFireStorage(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref("/images/$userId.png").putFile(file);
    } on FirebaseException catch (e) {
      print(e.message! + e.code);
    }
    return true;
  }

  Future<void> attemptToOverwriteFile(File file) async {
    String oldFilePath = await getLocalAvatarPath();
    File oldFile = File(oldFilePath);
    if (await oldFile.exists()) {
      oldFile.delete();
    }
    file.copy(oldFilePath);
  }

  Future<File?> imageFromCamera() async {
    PickedFile? image = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 100);
    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }

  Future<File?> imageFromGallery() async {
    PickedFile? image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }

  @override
  String toString() {
    return "firstName = $firstName, lastName = $lastName, userId = $userId, email = $email, avatarLink = $avatarLink";
  }
}
