import 'package:jogr/services/database.dart';

class User {

  final String uid;

  Map<String, dynamic> data;

  User({ this.uid }) {
    DatabaseService db = DatabaseService(uid: uid);

  }

}