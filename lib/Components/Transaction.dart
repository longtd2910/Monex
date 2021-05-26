import 'package:monex/Components/CustomObject.dart';

enum TransactionStatus {
  paid,
  planned,
  predicted,
  owed,
}

class Transaction {
  String id;
  String title;
  String description;
  double value;
  bool type;
  int category;
  Date date;

  Transaction(this.id, this.title, this.description, this.value, this.type, this.category, this.date);
}
