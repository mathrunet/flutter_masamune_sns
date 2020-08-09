part of masamune.sns;

/// Control widget for social media profiles.
class SNSProfileControl extends StatelessWidget {
  /// The user ID viewing the profile.
  final String userId;

  /// Edit profile button label.
  final String profileEditLabel;

  /// Processing when the edit profile button is tapped.
  final VoidAction onProfileEdit;

  /// Processing when the like button is tapped.
  final VoidAction onLike;

  /// Like button icon.
  final IconData likeIcon;

  /// True if followed.
  final bool isFollow;

  /// Follow label.
  final String followLabel;

  /// Unfollow label.
  final String unfollowLabel;

  /// Process when following.
  final VoidAction onFollow;

  /// Process when unfollowing.
  final VoidAction onUnfollow;

  /// Forces edit mode.
  final bool forceEditControl;

  /// Control widget for social media profiles.
  SNSProfileControl(
      {this.userId,
      this.profileEditLabel = "Edit Profile",
      this.onProfileEdit,
      this.onLike,
      this.likeIcon,
      this.isFollow = false,
      this.followLabel = "Follow",
      this.unfollowLabel = "Unfollow",
      this.onFollow,
      this.onUnfollow,
      this.forceEditControl = false});

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    if (this.forceEditControl || SNSUtility.isMyID(this.userId)) {
      return Container(
          constraints: BoxConstraints.expand(height: 50),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: FlatButton.icon(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: context.theme.textTheme.bodyText1.color),
                  borderRadius: BorderRadius.circular(8.0)),
              icon: const Icon(Icons.edit),
              label: Text(
                this.profileEditLabel.localize(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: this.onProfileEdit));
    } else {
      return Container(
          alignment: Alignment.centerRight,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: this.likeIcon != null
                    ? IconButton(
                        visualDensity: VisualDensity.standard,
                        icon: Icon(this.likeIcon,
                            size: 32, color: context.theme.primaryColor),
                        onPressed: this.onLike)
                    : Container()),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: UIScope(child: (context) {
                  if (this.isFollow) {
                    return FlatButton.icon(
                      shape: const StadiumBorder(),
                      icon:
                          const Icon(Icons.remove_circle, color: Colors.white),
                      label: Text(this.unfollowLabel.localize(),
                          style: const TextStyle(color: Colors.white)),
                      onPressed: this.onUnfollow,
                      color: context.theme.disabledColor,
                    );
                  } else {
                    return FlatButton.icon(
                      shape: const StadiumBorder(),
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      label: Text(this.followLabel.localize(),
                          style: const TextStyle(color: Colors.white)),
                      onPressed: this.onFollow,
                      color: context.theme.primaryColor,
                    );
                  }
                }))
          ]));
    }
  }
}
