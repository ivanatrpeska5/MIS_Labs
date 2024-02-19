import 'location.dart';

class Exam {
  int id;
  String name;
  DateTime dateTime;
  Location location;

  Exam({required this.id, required this.name, required this.dateTime, required this.location});
}
