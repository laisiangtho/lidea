part of view.user;

// ProfileIcon Profile

class TmpWorking extends StatelessWidget {
  final bool user;
  final String? photoURL;
  const TmpWorking({Key? key, this.user = false, this.photoURL}) : super(key: key);

  bool get hasUser => user;
  String? get userPhotoURL => photoURL;

  @override
  Widget build(BuildContext context) {
    return const Text('abc');
  }
}

class AbcWorking extends TmpWorking {
  bool get hasUser => true;
  String? get userPhotoURL => 'asdf';

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}

class UserIconWidget extends StatelessWidget {
  final bool signedIn;
  final String? photoURL;
  const UserIconWidget({Key? key, this.signedIn = false, this.photoURL}) : super(key: key);

  bool get userSignedIn => signedIn;
  String? get userPhotoURL => photoURL;

  @override
  Widget build(BuildContext context) {
    if (userSignedIn) {
      if (userPhotoURL != null) {
        return CircleAvatar(
          radius: 15,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   authenticate.userPhotoURL!,
              //   fit: BoxFit.cover,
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return const Padding(
                    // padding: EdgeInsets.all(3),
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      // size: 25,
                    ),
                  );
                },
                imageUrl: userPhotoURL!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
      return ClipOval(
        child: Material(
          elevation: 10,
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: .5,
            ),
          ),
          shadowColor: Theme.of(context).primaryColor,
          child: const Padding(
            // padding: EdgeInsets.all(3),
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.face_retouching_natural_rounded,
              // size: 25,
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Material(
        elevation: 30,
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).backgroundColor,
            width: .7,
          ),
        ),
        shadowColor: Theme.of(context).primaryColor,
        child: const Padding(
          padding: EdgeInsets.all(1),
          // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          // padding: EdgeInsets.zero,
          child: Icon(
            Icons.face,
            // size: 25,
          ),
        ),
      ),
    );
  }
}



// class UserIconWidget extends StatelessWidget {
//   final AuthenticateUnit authenticate;
//   const UserIconWidget({
//     Key? key,
//     required this.authenticate,
//   }) : super(key: key);

//   // AuthenticateUnit? get asdf => null;

//   @override
//   Widget build(BuildContext context) {
//     if (authenticate.hasUser) {
//       if (authenticate.userPhotoURL != null) {
//         return CircleAvatar(
//           radius: 15,
//           child: ClipOval(
//             child: Material(
//               // child: Image.network(
//               //   authenticate.userPhotoURL!,
//               //   fit: BoxFit.cover,
//               // ),
//               child: CachedNetworkImage(
//                 placeholder: (context, url) {
//                   return const Padding(
//                     // padding: EdgeInsets.all(3),
//                     padding: EdgeInsets.zero,
//                     child: Icon(
//                       Icons.face_retouching_natural_rounded,
//                       // size: 25,
//                     ),
//                   );
//                 },
//                 imageUrl: authenticate.userPhotoURL!,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         );
//       }
//       return ClipOval(
//         child: Material(
//           elevation: 10,
//           shape: CircleBorder(
//             side: BorderSide(
//               color: Theme.of(context).backgroundColor,
//               width: .5,
//             ),
//           ),
//           shadowColor: Theme.of(context).primaryColor,
//           child: const Padding(
//             // padding: EdgeInsets.all(3),
//             padding: EdgeInsets.zero,
//             child: Icon(
//               Icons.face_retouching_natural_rounded,
//               // size: 25,
//             ),
//           ),
//         ),
//       );
//     }

//     return ClipOval(
//       child: Material(
//         elevation: 30,
//         shape: CircleBorder(
//           side: BorderSide(
//             color: Theme.of(context).backgroundColor,
//             width: .7,
//           ),
//         ),
//         shadowColor: Theme.of(context).primaryColor,
//         child: const Padding(
//           padding: EdgeInsets.all(1),
//           // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//           // padding: EdgeInsets.zero,
//           child: Icon(
//             Icons.face,
//             // size: 25,
//           ),
//         ),
//       ),
//     );
//   }
// }
