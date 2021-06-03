import 'dart:io';

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
    var getDirectory = await getApplicationDocumentsDirectory();
    var folderPath = getDirectory.path;
    var filePath = folderPath + "/images/$userId.jpg";
    await Directory(folderPath).create(recursive: true);
    File image = new File(filePath);
    await image.create(recursive: true);
    avatarLocalPath = filePath;
    await image.writeAsBytes(response.bodyBytes);
    return true;
  }

  @override
  String toString() {
    return "firstName = $firstName, lastName = $lastName, userId = $userId, email = $email, avatarLink = $avatarLink";
  }
}
