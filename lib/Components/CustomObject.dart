import 'package:intl/intl.dart';

class Date {
  int timeStamp;
  late String dateString;
  late DateTime date;
  final DateFormat formatter = DateFormat('hh:mm a');

  Date(this.timeStamp) {
    this.date = DateTime.fromMillisecondsSinceEpoch(timeStamp).toLocal();
    this.dateString = formatter.format(this.date);
  }
}
