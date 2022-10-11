import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lidea/crypto.dart';
// import 'package:lidea/firebase/core.dart';
import 'package:lidea/firebase/auth.dart';
import 'package:lidea/main.dart';
import 'package:lidea/unit/notify.dart';

import 'package:lidea/sign_in_with/google.dart';
import 'package:lidea/sign_in_with/facebook.dart';
import 'package:lidea/sign_in_with/apple.dart';

abstract class AuthenticateUnit extends Notify {
  final DataNest data;

  final String? name;
  final FirebaseOptions? options;
  final String? appleServiceId;
  final String? redirectUri;

  AuthenticateUnit({
    required this.data,
    this.name,
    this.options,
    this.appleServiceId,
    this.redirectUri,
  });

  late final GoogleSignIn _google = GoogleSignIn();

  bool _amoment = false;
  bool get amoment => _amoment;
  set amoment(bool value) => notifyIf<bool>(_amoment, _amoment = value);

  String _message = '';
  String get message => _message;
  set message(String value) => notifyIf<String>(_message, _message = value);

  // bool _isAvailableApple = false;
  // bool get isAvailableApple => _isAvailableApple;
  // set isAvailableApple(bool value) => _isAvailableApple = value;

  late bool showApple;
  late bool showFacebook;

  FirebaseAuth get app => FirebaseAuth.instance;
  User? get user => app.currentUser;
  bool get hasUser => user != null;

  String get id => userEmail.isNotEmpty ? getMd5(userEmail) : '';

  Future<void> deleteAccount() async {
    if (user == null) return;

    try {
      await user?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        message = e.message!;
      } else {
        message = 'Error occurred';
      }
      return Future.error(e);
    }
  }

  String get userDisplayname {
    if (hasUser) {
      if (user!.displayName != null) {
        return user!.displayName!;
      } else {
        final index = user!.providerData.indexWhere((e) => e.displayName != null);
        if (index >= 0) {
          final ob = user!.providerData.elementAt(index);
          return ob.displayName!;
        }
      }
    }
    return '';
  }

  String get userEmail {
    String value = '';
    if (hasUser) {
      if (user!.email != null) {
        value = user!.email!;
      } else {
        final index = user!.providerData.indexWhere((e) => e.email != null);
        if (index >= 0) {
          final ob = user!.providerData.elementAt(index);
          value = ob.email!;
        }
      }
    }
    return value;
  }

  String? get userPhotoURL {
    if (hasUser) {
      if (user!.photoURL != null) {
        return user!.photoURL!;
      } else {
        final index = user!.providerData.indexWhere((e) => e.photoURL != null);
        if (index >= 0) {
          final ob = user!.providerData.elementAt(index);
          return ob.photoURL!;
        }
      }
    }
    return null;
  }

  // user.uid;
  // user.phoneNumber;
  // user.user
  // user.email
  // user.photoURL
  Future<void> ensureInitialized() async {
    showFacebook = true;
    // showApple = !kIsWeb && Platform.isIOS && appleServiceId != null && redirectUri != null;
    showApple = data.isPlatform('ios') && appleServiceId != null && redirectUri != null;
    // if (!kIsWeb) {
    //   return;
    // }
    // if (showApple) {
    //   showApple = await SignInWithApple.isAvailable();
    // }

    // await Firebase.initializeApp(name: name, options: options);
    FirebaseAuth.instanceFor(app: Firebase.app());
    _stateObserver();
  }

  void _stateObserver() {
    // app.authStateChanges().listen((User? o) {});
    // app.idTokenChanges().listen((User? user) {});
    // if (hasUser) {
    //   final uid = user!.uid;
    //   final email = user!.email;
    //   final displayName = user!.displayName;
    //   final photoURL = user!.photoURL;
    // }
    app.userChanges().listen((o) {
      notify();
    });
    // app.idTokenChanges().listen((User? user) {});
    // if (hasUser) {
    //   final uid = user!.uid;
    //   final email = user!.email;
    //   final displayName = user!.displayName;
    //   final photoURL = user!.photoURL;
    // }
  }

  Stream<User?> get stream => app.authStateChanges();

  // Future<void> stateObserver([void Function(User? user)? observe]) async {
  //   app.userChanges().listen((o) {
  //     _message = (o == null) ? 'Not signed' : 'Signed';
  //     // notify();
  //     if (observe != null) {
  //       observe.call(o);
  //     }
  //   });
  // }

  Future<void> signInWithGoogle() async {
    amoment = true;
    // if (kIsWeb) {
    //   GoogleAuthProvider authProvider = GoogleAuthProvider();
    //   try {
    //     await app.signInWithPopup(authProvider);
    //   } catch (e) {
    //     'kIsWeb Error occurred using Google';
    //   }
    // }
    GoogleSignInAccount? google = await _google.signInSilently();
    google ??= await _google.signIn();
    if (google != null) {
      final GoogleSignInAuthentication auth = await google.authentication;
      try {
        await app.signInWithCredential(GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        ));

        if (hasUser) {
          if (google.photoUrl != user!.photoURL) {
            await user!.updatePhotoURL(google.photoUrl);
            user!.reload();
          }
        }
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
    final LoginResult res = await FacebookAuth.instance.login(
      // permissions: const ['email', 'public_profile', 'user_hometown', 'user_birthday'],
      permissions: const ['email', 'public_profile'],
    );

    if (res.status == LoginStatus.success) {
      final facebookCredential = FacebookAuthProvider.credential(res.accessToken!.token);

      // print(res.accessToken!.token);
      try {
        await app.signInWithCredential(facebookCredential);

        final facebook = await FacebookAuth.instance.getUserData(
          // fields: "name,email,picture.width(300),hometown,birthday",
          fields: 'name,email,picture.width(300)',
        );
        if (hasUser) {
          final photo = facebook['picture']['data']['url'];

          // print(facebook.toString());
          // final photo = '${user!.photoURL}?height=100&access_token=${res.accessToken!.token}';
          if (photo != null) {
            await user!.updatePhotoURL(photo);
            user!.reload();
          }
        }
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
        // print(e);
        message = 'Error occurred using Facebook';
      }
    }
    amoment = false;
  }

  Future<void> signInWithApple() async {
    amoment = true;
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // NOTE: Set the `clientId` and `redirectUri`
          // arguments to the values you entered in the
          // Apple Developer portal during the setup
          clientId: appleServiceId!,

          redirectUri: Uri.parse(redirectUri!),
        ),
      );

      // final appleAuth = OAuthProvider('apple.com').credential(
      //   accessToken: appleCredential.authorizationCode,
      //   idToken: appleCredential.identityToken,
      // );

      await app.signInWithCredential(
        OAuthProvider('apple.com').credential(
          accessToken: appleCredential.authorizationCode,
          idToken: appleCredential.identityToken,
        ),
      );
    } on SignInWithAppleNotSupportedException catch (e) {
      message = e.message;
    } on SignInWithAppleAuthorizationException catch (e) {
      message = e.message;
    } on PlatformException catch (e) {
      if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      } else {
        message = e.toString();
      }
    } on SignInWithAppleException catch (e) {
      message = e.toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        await signInAccountAlreadyExistsHandler(e);
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid credential';
      } else {
        message = 'Error occurred';
      }
    }
    amoment = false;
  }

  // account-exists-with-different-credential
  // The account already exists with a different credential
  // An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.
  Future<void> signInAccountAlreadyExistsHandler(FirebaseAuthException e) async {
    // String email = e.email!;
    AuthCredential? pendingCredential = e.credential;
    // Fetch a list of what sign-in methods exist for the conflicting user

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

    // List<String> userSignInMethods = await app.fetchSignInMethodsForEmail(email);
    // Since other providers are now external, you must now sign the user in with another
    // if (userSignInMethods.first == 'google.com') {}
    // if (userSignInMethods.first == 'facebook.com') {}

    GoogleSignInAccount? account = await _google.signInSilently();
    account ??= await _google.signIn();

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

  Future<void> signOut() async {
    // if (!kIsWeb) await google.signOut();
    try {
      await app.signOut();
      // await FacebookAuth.instance.logOut();
      message = '';
    } catch (e) {
      message = 'Error signing out. Try again.';
    }
  }
}
