import 'package:encrypt/encrypt.dart';

class Crypter {
  static final key = Key.fromLength(32);
  static final iv = IV.fromLength(16);

  static String encrypt(String value) {
    var encrypted = Encrypter(AES(key)).encrypt(value, iv: iv).base64;
    print(encrypted);
    return encrypted;
  }

  static String decrypt(String value) {
    var decrypted = Encrypter(AES(key)).decrypt64(value);
    print(decrypted);
    return decrypted;
  }
}

class TypeConvert {
  static List<String> nameConvert(String? value) {
    if (!value!.contains(" ")) {
      return [value, ""];
    }
    String lastName = "";
    List<String> separateSpace = value.split(" ");
    for (int i = 1; i < separateSpace.length; ++i) {
      lastName += separateSpace[i];
      if (i != separateSpace.length - 1) {
        lastName += " ";
      }
    }
    return [separateSpace[0], lastName];
  }
}
