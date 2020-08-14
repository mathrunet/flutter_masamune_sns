part of masamune.sns;

/// Chat message item (text)
class SNSChatMessageText extends StatelessWidget {
  /// Message text.
  final String text;

  /// Avatar image.
  final ImageProvider avatar;

  /// True for own messages.
  final bool mine;

  /// Date format.
  final DateFormat dateFormat;

  /// Date and time of posting.
  final DateTime dateTime;

  /// The background color of the text.
  final Color textBackgroundColor;

  /// Text color.
  final Color textColor;

  /// Post date text color.
  final Color timeColor;

  /// Chat message item (text)
  SNSChatMessageText(
      {@required this.text,
      @required this.avatar,
      this.mine = false,
      this.dateFormat,
      this.dateTime,
      this.textBackgroundColor,
      this.textColor,
      this.timeColor});

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!this.mine)
              Container(
                  width: 50,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                          backgroundColor: context.theme.canvasColor,
                          backgroundImage: this.avatar))),
            if (this.mine) Container(width: 50),
            Expanded(
                flex: 5,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: this.textBackgroundColor ??
                                context.theme.disabledColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(this.text ?? Const.empty,
                            style: TextStyle(
                                color: this.textColor ??
                                    context.theme.backgroundColor)),
                      ),
                      if (this.dateTime != null)
                        Text(
                            (this.dateFormat ?? DateFormat("HH:mm"))
                                .format(this.dateTime),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: this.timeColor ??
                                    context.theme.disabledColor))
                    ])),
            if (this.mine)
              Container(
                  width: 50,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                          backgroundColor: context.theme.canvasColor,
                          backgroundImage: this.avatar))),
            if (!this.mine) Container(width: 50),
          ],
        ));
  }
}
