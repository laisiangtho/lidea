part of 'main.dart';

// ProfileIcon Profile
class UserIcon extends StatelessWidget {
  final UnitAuthentication authenticate;
  const UserIcon({Key? key, required this.authenticate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (authenticate.hasUser) {
      if (authenticate.userPhotoURL != null) {
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
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: 25,
                    ),
                  );
                },
                imageUrl: authenticate.userPhotoURL!,
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
            padding: EdgeInsets.all(3),
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
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.face,
            size: 25,
          ),
        ),
      ),
    );
  }
}
