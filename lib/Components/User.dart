import 'package:monex/Components/Transaction.dart';

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
  String? imageAssets;
  double? balance;
  List<SignInType> signInType;
  List<Transaction>? lstTransaction;
  String? email;
  Gender? gender;

  User(this.userId, this.signInType);
}
