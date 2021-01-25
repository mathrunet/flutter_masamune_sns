part of masamune.sns;

/// Timeline list tile widget for SNS.
class SNSTimelineListTile extends StatefulWidget {
  /// Avatar image for the user.
  final ImageProvider avatar;

  /// Content padding.
  final EdgeInsets padding;

  /// User name.
  final String name;

  /// User sub name.
  final String subname;

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

  /// If true, the bottom divider is displayed.
  final bool showDivider;

  /// Sets the maximum number of lines to display.
  final int maxLines;

  /// Ellipsis text.
  final String ellipsisText;

  /// Read more text.
  final String readModeText;

  /// Process when read more text is tapped.
  final Function onTapReadMore;

  /// Timeline list tile widget for SNS.
  SNSTimelineListTile(
      {this.avatar,
      this.name,
      this.onTapProfile,
      this.image,
      this.subname,
      this.likeCount,
      this.maxLines,
      this.onTapReadMore,
      this.readModeText = "Read more",
      this.ellipsisText = "\n...",
      this.padding = const EdgeInsets.only(top: 10),
      this.likeIcon,
      this.text,
      this.showDivider = true,
      this.onTap,
      this.onTapLike,
      this.dateFormat,
      this.time});

  @override
  State<StatefulWidget> createState() => _SNSTimelineListTileState();
}

class _SNSTimelineListTileState extends State<SNSTimelineListTile> {
  String _text;
  bool _isMaxLine = false;
  void initState() {
    super.initState();
    if (this.widget.maxLines != null && this.widget.maxLines > 0) {
      List<String> tmp = this.widget.text?.split("\n");
      if (tmp.length > this.widget.maxLines) {
        this._isMaxLine = true;
        this._text = tmp?.sublist(0, this.widget.maxLines)?.join("\n");
      } else {
        this._text = this.widget.text;
      }
    } else {
      this._text = this.widget.text;
    }
  }

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.widget.onTap,
        child: Padding(
            padding: this.widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (this.widget.name != null || this.widget.avatar != null)
                  Container(
                      child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    dense: true,
                    onTap: () {
                      if (this.widget.onTapProfile != null)
                        this.widget.onTapProfile();
                    },
                    leading: (this.widget.avatar != null)
                        ? Container(
                            width: 35,
                            height: 35,
                            child: CircleAvatar(
                              backgroundColor: context.theme.disabledColor,
                              backgroundImage: this.widget.avatar,
                            ))
                        : null,
                    title: Text(this.widget.name ?? Const.empty,
                        style: isNotEmpty(this.widget.subname)
                            ? null
                            : context.theme.textTheme.headline6),
                    subtitle: isEmpty(this.widget.subname)
                        ? null
                        : Text(this.widget.subname),
                  )),
                if (this.widget.image != null)
                  Container(
                      color: context.theme.canvasColor,
                      constraints: BoxConstraints.expand(height: 200),
                      child:
                          Image(image: this.widget.image, fit: BoxFit.cover)),
                if (this.widget.likeIcon != null)
                  Container(
                      constraints: BoxConstraints.expand(height: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: this.widget.likeIcon,
                            onPressed: () {
                              if (this.widget.onTapLike != null)
                                this.widget.onTapLike();
                            },
                          ),
                          if (this.widget.likeCount != null)
                            this.widget.likeCount
                        ],
                      )),
                if (this.widget.likeIcon == null && this.widget.image != null)
                  Space(),
                if (this.widget.text != null)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: UIText(
                        this.widget.text,
                      )),
                if (this._isMaxLine)
                  FlatButton(
                      onPressed: () {
                        if (this.widget.onTapReadMore != null) {
                          this.widget.onTapReadMore();
                        } else if (this.widget.onTap != null) {
                          this.widget.onTap();
                        }
                      },
                      child: Text(this.widget.readModeText)),
                if (this.widget.time != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                        (this.widget.dateFormat ?? DateFormat.yMd().add_Hms())
                            .format(this.widget.time),
                        style: context.theme.textTheme.caption),
                  ),
                if (this.widget.showDivider) Divider()
              ],
            )));
  }
}
