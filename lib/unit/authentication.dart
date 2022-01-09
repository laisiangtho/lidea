import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lidea/crypto.dart';
import 'package:lidea/firebase_core.dart';
import 'package:lidea/firebase_auth.dart';
import 'package:lidea/google_signin.dart';
import 'package:lidea/facebook_signin.dart';
import 'package:lidea/unit/notify.dart';

abstract class UnitAuthentication extends Notify {
  // static Authentication of(BuildContext context) {
  //   return Authentication.of(context);
  // }

  // late void Function(User? user)? observer;
  final String? name;
  final FirebaseOptions? options;

  UnitAuthentication({this.name, this.options});

  late final GoogleSignIn _google = GoogleSignIn();
  bool _amoment = false;
  bool get amoment => _amoment;
  set amoment(bool value) => notifyIf<bool>(_amoment, _amoment = value);

  String _message = 'Not signed';
  String get message => _message;
  set message(String value) => notifyIf<String>(_message, _message = value);

  FirebaseAuth get app => FirebaseAuth.instance;
  User? get user => app.currentUser;
  bool get hasUser => user != null;
  String get userEmail => (hasUser && user!.email != null) ? user!.email! : '';
  String get id => userEmail.isNotEmpty ? getMd5(userEmail) : '';

  // user.uid;
  // user.phoneNumber;
  // user.user
  // user.email
  // user.photoURL
  Future<void> ensureInitialized() async {
    await Firebase.initializeApp(name: name, options: options);
    FirebaseAuth.instanceFor(app: Firebase.app());
  }

  Future<void> stateObserver([void Function(User? user)? observe]) async {
    // app.authStateChanges().listen((User? o) {});
    // app.idTokenChanges().listen((User? user) {});
    // if (hasUser) {
    //   final uid = user!.uid;
    //   final email = user!.email;
    //   final displayName = user!.displayName;
    //   final photoURL = user!.photoURL;
    // }
    app.userChanges().listen((o) {
      _message = (o == null) ? 'Not signed' : 'Signed';
      // notify();
      if (observe != null) {
        observe.call(o);
      }
    });
    // app.idTokenChanges().listen((User? user) {});
    // if (hasUser) {
    //   final uid = user!.uid;
    //   final email = user!.email;
    //   final displayName = user!.displayName;
    //   final photoURL = user!.photoURL;
    // }
  }

  Future<void> signInWithGoogle() async {
    amoment = true;
    // if (kIsWeb) {
    //   GoogleAuthProvider authProvider = GoogleAuthProvider();
    //   try {
    //     await app.signInWithPopup(authProvider);
    //   } catch (e) {
    //     message = 'kIsWeb Error occurred using Google';
    //   }
    // }
    GoogleSignInAccount? res = await _google.signInSilently();
    if (res == null) {
      res = await _google.signIn();
    }
    if (res != null) {
      final GoogleSignInAuthentication auth = await res.authentication;
      try {
        await app.signInWithCredential(GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        ));
      } on PlatformException catch (e) {
        message = e.toString();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          await signInAccountAlreadyExistsHandler(e);
        } else if (e.code == 'invalid-credential') {
          message = 'Invalid credential';
        } else {
          message = 'Error occurred';
        }
      } catch (e) {
        message = 'Error occurred using Google';
      }
    }
    amoment = false;
  }

  Future<void> signInWithFacebook() async {
    amoment = true;
    final LoginResult res = await FacebookAuth.instance.login();
    if (res.status == LoginStatus.success) {
      try {
        await app.signInWithCredential(
          FacebookAuthProvider.credential(res.accessToken!.token),
        );
      } on PlatformException catch (e) {
        message = e.toString();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          await signInAccountAlreadyExistsHandler(e);
        } else if (e.code == 'invalid-credential') {
          message = 'Invalid credential';
        } else {
          message = 'Error occurred';
        }
      } catch (e) {
        message = 'Error occurred using Facebook';
      }
    }
    amoment = false;
  }

  // account-exists-with-different-credential
  // The account already exists with a different credential
  // An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.
  Future<void> signInAccountAlreadyExistsHandler(FirebaseAuthException e) async {
    String email = e.email!;
    AuthCredential? pendingCredential = e.credential;
    // Fetch a list of what sign-in methods exist for the conflicting user
    List<String> userSignInMethods = await app.fetchSignInMethodsForEmail(email);

    // If the user has several sign-in methods,
    // the first method in the list will be the "recommended" method to use.
    // if (userSignInMethods.first == 'password') {
    //   // Prompt the user to enter their password
    //   String password = '...';

    //   // Sign the user in to their account with the password
    //   UserCredential userCredential =
    //       await app.signInWithEmailAndPassword(email: email, password: password);

    //   // Link the pending credential with the existing account
    //   await userCredential.user!.linkWithCredential(pendingCredential!);
    // }

    // Since other providers are now external, you must now sign the user in with another
    if (userSignInMethods.first == 'google.com') {
      GoogleSignInAccount? account = await _google.signInSilently();
      if (account == null) {
        account = await _google.signIn();
      }

      // Obtain the auth details from the request.
      final auth = await account!.authentication;
      // Create a new credential.
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      await app.signInWithCredential(credential);
      if (pendingCredential != null) {
        await user!.linkWithCredential(pendingCredential);
      }
    }

    // if (userSignInMethods.first == 'facebook.com') {
    //   final token = await FacebookAuth.instance.accessToken;
    //   final credential = FacebookAuthProvider.credential(token as String);
    //   // Sign the user in with the credential
    //   UserCredential userCredential = await app.signInWithCredential(credential);
    //   // Link the pending credential with the existing account
    //   await userCredential.user!.linkWithCredential(pendingCredential!);
    // }
  }

  Future<void> signOut() async {
    // if (!kIsWeb) await google.signOut();
    try {
      await app.signOut();
      // await FacebookAuth.instance.logOut();
      message = 'Signed out';
    } catch (e) {
      message = 'Error signing out. Try again.';
    }
  }
}