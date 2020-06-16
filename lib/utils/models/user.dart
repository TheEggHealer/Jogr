import 'package:learningflutter2/services/database.dart';

class User {

  final String uid;

  Map<String, dynamic> data;

  User({ this.uid }) {
    DatabaseService db = DatabaseService(uid: uid);

  }

}