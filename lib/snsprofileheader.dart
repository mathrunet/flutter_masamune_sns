part of masamune.sns;

/// SNS profile header.
class SNSProfileHeader extends StatelessWidget {
  /// Process when tapping follow.
  final VoidAction onTapFollow;

  /// Processing when a follower is tapped.
  final VoidAction onTapFollower;

  /// Builder to get follow count.
  final int Function(BuildContext context) followCountBuilder;

  /// Builder to get follower count.
  final int Function(BuildContext context) followerCountBuilder;

  /// Builder for getting images.
  final ImageProvider Function(BuildContext context) imageBuilder;

  /// Builder to get the name.
  final String Function(BuildContext context) nameBuilder;

  /// Builder for getting text.
  final String Function(BuildContext context) textBuilder;

  /// Follow text.
  final String followText;

  /// Follower text.
  final String followerText;

  /// Name postfix.
  final String namePostfix;

  /// SNS profile header.
  SNSProfileHeader(
      {this.imageBuilder,
      this.onTapFollow,
      this.onTapFollower,
      this.followCountBuilder,
      this.followerCountBuilder,
      @required this.nameBuilder,
      @required this.textBuilder,
      this.followText = "Follow",
      this.followerText = "Follower",
      this.namePostfix = ""})
      : assert(nameBuilder != null),
        assert(textBuilder != null);

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    flex: 1,
                    child: UIScope(
                        child: (context) => Container(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                                backgroundColor: context.theme.canvasColor,
                                backgroundImage: this.imageBuilder(context))))),
                if (followerCountBuilder != null &&
                    isNotEmpty(this.followerText))
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () {
                            if (this.onTapFollower != null)
                              this.onTapFollower();
                          },
                          child: Container(
                              height: 100,
                              color: context.theme.backgroundColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  UIText((context) {
                                    if (this.followerCountBuilder == null)
                                      return "0";
                                    return this
                                            .followerCountBuilder(context)
                                            ?.toString() ??
                                        "0";
                                  }, style: context.theme.textTheme.headline6),
                                  Text(this.followerText.localize())
                                ],
                              )))),
                if (followCountBuilder != null && isNotEmpty(this.followText))
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () {
                            if (this.onTapFollow != null) this.onTapFollow();
                          },
                          child: Container(
                              height: 100,
                              color: context.theme.backgroundColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  UIText((context) {
                                    if (this.followCountBuilder == null)
                                      return "0";
                                    return this
                                            .followCountBuilder(context)
                                            ?.toString() ??
                                        "0";
                                  }, style: context.theme.textTheme.headline6),
                                  Text(this.followText.localize())
                                ],
                              ))))
              ],
            )),
        Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 20),
            child: UIText(
                (context) => "${this.nameBuilder(context)} $namePostfix\n"
                    "${this.textBuilder(context)}")),
      ],
    );
  }
}
