import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jogr/utils/models/userdata.dart';

class DatabaseService {

  final String uid;

  final CollectionReference userData = Firestore.instance.collection('userData');

  DatabaseService({ this.uid });

  Future updateUserData(bool setup, String name, String dob, double weight) async {
    return await userData.document(uid).setData({
      'setup': false,
    });
  }

  Future mergeUserDataFields(Map<String, dynamic> fields) async {
    return await userData.document(uid).setData(fields, merge: true);
  }



  Future<bool> checkExist() async {
    try {
      bool exists = false;
      await userData.document(uid).get().then((doc) => exists = doc.exists);
      return exists;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  UserData _userDataFromDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> raw = snapshot.data;
    UserData data = UserData(
        raw: raw,
    );

    data.setupExisting();

    return data;
  }

  Stream<UserData> get userDocument {
    return userData.document(uid).snapshots().map(_userDataFromDocument);
  }

}