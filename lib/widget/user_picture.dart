part of lidea.widget;

class UserPicture extends StatelessWidget {
  final UnitAuthentication authenticate;
  final double snapShrink;
  const UserPicture({
    Key? key,
    required this.authenticate,
    required this.snapShrink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (authenticate.hasUser) {
      if (authenticate.userPhotoURL != null) {
        return CircleAvatar(
          // radius: 50,
          radius: (35 * snapShrink + 15).toDouble(),
          // backgroundColor: Theme.of(context).backgroundColor,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   user.photoURL!,
              //   fit: BoxFit.cover,
              //   // height: (70 * org.snapShrink + 30).toDouble(),
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return Padding(
                    padding: EdgeInsets.all((7 * snapShrink + 3).toDouble()),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: (70 * snapShrink).clamp(25, 70).toDouble(),
                    ),
                  );
                },
                // imageUrl: user.photoURL!,
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
          child: Padding(
            padding: EdgeInsets.all((7 * snapShrink + 3).toDouble()),
            child: Icon(
              Icons.face_retouching_natural_rounded,
              size: (70 * snapShrink).clamp(25, 70).toDouble(),
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
        child: Padding(
          padding: EdgeInsets.all((7 * snapShrink + 3).toDouble()),
          child: Icon(
            Icons.face,
            color: Theme.of(context).hintColor,
            size: (70 * snapShrink).clamp(25, 70).toDouble(),
          ),
        ),
      ),
    );
  }
}
