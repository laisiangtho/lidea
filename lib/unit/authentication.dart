import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lidea/crypto.dart';
import 'package:lidea/firebase_core.dart';
import 'package:lidea/firebase_auth.dart';
import 'package:lidea/signin_with_google.dart';
import 'package:lidea/signin_with_apple.dart';
import 'package:lidea/signin_with_facebook.dart';
import 'package:lidea/unit/notify.dart';

abstract class UnitAuthentication extends Notify {
  final String? name;
  final FirebaseOptions? options;
  final String? appleServiceId;
  final String? redirectUri;

  UnitAuthentication({
    this.name,
    this.options,
    this.appleServiceId,
    this.redirectUri,
  });

  late final GoogleSignIn _google = GoogleSignIn();

  bool _amoment = false;
  bool get amoment => _amoment;
  set amoment(bool value) => notifyIf<bool>(_amoment, _amoment = value);

  String _message = 'Not signed';
  String get message => _message;
  set message(String value) => notifyIf<String>(_message, _message = value);

  bool _isAvailableApple = false;
  bool get isAvailableApple => _isAvailableApple;
  set isAvailableApple(bool value) => _isAvailableApple = value;

  FirebaseAuth get app => FirebaseAuth.instance;
  User? get user => app.currentUser;
  bool get hasUser => user != null;

  String get id => userEmail.isNotEmpty ? getMd5(userEmail) : '';

  // TODO: all changes need to update to music, dictionary

  String get userDisplayname {
    String value = '';
    if (hasUser) {
      if (user!.displayName != null) {
        value = user!.displayName!;
      } else {
        final index = user!.providerData.indexWhere((e) => e.displayName != null);
        if (index >= 0) {
          final ob = user!.providerData.elementAt(index);
          value = ob.displayName!;
        }
      }
    }
    return value;
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
    isAvailableApple = await SignInWithApple.isAvailable();
    if (isAvailableApple) {
      isAvailableApple = Platform.isIOS && appleServiceId != null && redirectUri != null;
    }
    await Firebase.initializeApp(name: name, options: options);
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
    final LoginResult res =
        await FacebookAuth.instance.login(permissions: const ['email', 'public_profile']);

    if (res.status == LoginStatus.success) {
      try {
        // final facebookAuth = FacebookAuthProvider();
        final facebookAuthCredential = FacebookAuthProvider.credential(res.accessToken!.token);
        print('token: ${res.accessToken!.token}');

        // final appleCredential = res.accessToken!;
        // appleCredential.accessToken
        // appleCredential.accessToken;
        // appleCredential.idToken;
        // OAuthProvider('facebook.com').credential(
        //     accessToken: appleCredential.accessToken,
        //     idToken: appleCredential.idToken,
        //   ),

        await app.signInWithCredential(facebookAuthCredential);
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
      print('message: $message');
    }
    print(res.status);
    amoment = false;
  }

  Future<void> signInWithApple() async {
    if (!isAvailableApple) {
      return;
    }
    amoment = true;

    try {
      final appleAuthCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: Set the `clientId` and `redirectUri`
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
          accessToken: appleAuthCredential.authorizationCode,
          idToken: appleAuthCredential.identityToken,
        ),
      );
    } on PlatformException catch (e) {
      message = e.toString();
      print(e);
    } on SignInWithAppleException catch (e) {
      message = e.toString();
      print(e);
      // } on SignInWithAppleAuthorizationException catch (e) {
      //   message = e.toString();
      //   print(e);
    } on FirebaseAuthException catch (e) {
      print(e);
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
    } catch (e) {
      message = 'Error signing out. Try again.';
    }
  }
}
