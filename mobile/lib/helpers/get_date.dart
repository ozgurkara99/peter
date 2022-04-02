import 'package:intl/intl.dart';

// Get data in desired format
String getDateInString() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd-kk:mm');
  return formatter.format(now);
}
