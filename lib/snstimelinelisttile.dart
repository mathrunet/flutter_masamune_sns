part of masamune.sns;

/// Timeline list tile widget for SNS.
class SNSTimelineListTile extends StatelessWidget {
  /// Avatar image for the user.
  final ImageProvider avatar;

  /// Content padding.
  final EdgeInsets padding;

  /// User name.
  final String name;

  /// What happens when you tap your profile.
  final VoidAction onTapProfile;

  /// The image of the article.
  final ImageProvider image;

  /// Like icon.
  final Icon likeIcon;

  /// Like count.
  final Widget likeCount;

  /// The text of the article.
  final String text;

  /// Process when like is tapped.
  final VoidAction onTapLike;

  /// Date format.
  final DateFormat dateFormat;

  /// The date of the article.
  final DateTime time;

  /// Process when timeline is tapped.
  final Function onTap;

  /// Timeline list tile widget for SNS.
  SNSTimelineListTile(
      {this.avatar,
      this.name,
      this.onTapProfile,
      this.image,
      this.likeCount,
      this.padding = const EdgeInsets.all(0),
      this.likeIcon,
      this.text,
      this.onTap,
      this.onTapLike,
      this.dateFormat,
      this.time});

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.onTap,
        child: Padding(
            padding: this.padding,
            child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (this.name != null || this.avatar != null)
                      Container(
                          child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              dense: true,
                              onTap: () {
                                if (this.onTapProfile != null)
                                  this.onTapProfile();
                              },
                              leading: (this.avatar != null)
                                  ? Container(
                                      width: 35,
                                      height: 35,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            context.theme.disabledColor,
                                        backgroundImage: this.avatar,
                                      ))
                                  : null,
                              title: Text(this.name ?? Const.empty,
                                  style: context.theme.textTheme.headline6))),
                    if (this.image != null)
                      Container(
                          color: context.theme.canvasColor,
                          constraints: BoxConstraints.expand(height: 200),
                          child: Image(image: this.image, fit: BoxFit.cover)),
                    if (this.likeIcon != null)
                      Container(
                          constraints: BoxConstraints.expand(height: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: this.likeIcon,
                                onPressed: () {
                                  if (this.onTapLike != null) this.onTapLike();
                                },
                              ),
                              if (this.likeCount != null) this.likeCount
                            ],
                          )),
                    if (this.likeIcon == null && this.image != null) Space(),
                    if (this.text != null)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(this.text)),
                    if (this.time != null)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(
                              (this.dateFormat ?? DateFormat.yMd().add_Hms())
                                  .format(this.time),
                              style: context.theme.textTheme.caption)),
                    Divider()
                  ],
                ))));
  }
}
