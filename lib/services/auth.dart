import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_toUser);
  }

  // create User object based on firebase user
  User _toUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _toUser(user);
    } catch(e) {

      //Failed to login
      print(e.toString());
      return null;
    }
  }

  // sign in google
  Future signInGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    DatabaseService db = DatabaseService(uid: user.uid);
    if(!(await db.checkExist())) {
      print('creating new document');
      await db.updateUserData(false, '', '', 0);
    } else {
      print('document already exists');
    }

    return _toUser(currentUser);
  }

  Future loginEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      DatabaseService db = DatabaseService(uid: user.uid);
      if(!(await db.checkExist())) {
        print('creating new document');
        await db.updateUserData(false, '', '', 0);
      } else {
        print('document already exists');
      }

      return _toUser(user);
    } catch(e) {
      print(e.toString());
      switch(e.code) {
        case 'ERROR_USER_NOT_FOUND' : return 'Invalid combination of email and password.';
        case 'ERROR_WRONG_PASSWORD' : return 'Invalid combination of email and password.';
        default: return 'Login failed.';
      }
    }
  }

  // register email & pass
  Future registerEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //Create new document in firestore database
      await DatabaseService(uid: user.uid).updateUserData(false, '', '', 0);

      return _toUser(user);
    } catch(e) {
      print(e.toString());
      switch(e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE' : return 'Email is already taken.';
        default: return 'Login failed.';
      }
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  signOutGoogle() async {
    try {
      return await _googleSignIn.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}