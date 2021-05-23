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
