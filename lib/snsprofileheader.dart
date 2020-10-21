part of masamune.sns;

/// SNS profile header.
class SNSProfileHeader extends StatelessWidget {
  /// Builder for getting images.
  final ImageProvider Function(BuildContext context) imageBuilder;

  /// Builder to get the name.
  final Widget Function(BuildContext context) nameBuilder;

  /// Builder for getting text.
  final Widget Function(BuildContext context) textBuilder;

  /// Builder for get the prefix.
  final Widget Function(BuildContext context) prefixBuilder;

  /// Header item.
  final List<SNSProfileHeaderItem> items;

  /// Image size.
  final double imageSize;

  /// SNS profile header.
  SNSProfileHeader(
      {this.imageBuilder,
      this.items,
      this.prefixBuilder,
      @required this.nameBuilder,
      @required this.textBuilder,
      this.imageSize = 100})
      : assert(nameBuilder != null),
        assert(textBuilder != null);

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    Widget prefix = this.prefixBuilder?.call(context);
    Widget name = this.nameBuilder?.call(context);
    Widget text = this.textBuilder?.call(context);
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
                            width: this.imageSize,
                            height: this.imageSize,
                            child: CircleAvatar(
                                backgroundColor: context.theme.disabledColor,
                                backgroundImage: this.imageBuilder(context))))),
                if (this.items != null)
                  for (SNSProfileHeaderItem item in this.items)
                    Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () {
                              if (item.onTap != null) item.onTap();
                            },
                            child: Container(
                                height: 100,
                                color: context.theme.backgroundColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    UIText((context) {
                                      if (item.countBuilder == null) return "0";
                                      return item
                                              .countBuilder(context)
                                              ?.toString() ??
                                          "0";
                                    },
                                        style:
                                            context.theme.textTheme.headline6),
                                    Text(item.title?.localize())
                                  ],
                                )))),
              ],
            )),
        if (name != null || text != null)
          Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (prefix != null) prefix,
                    if (name != null) name,
                    if (text != null) text,
                  ])),
      ],
    );
  }
}

/// Item for header.
class SNSProfileHeaderItem {
  /// Processing when tapped.
  final Function onTap;

  /// Title.
  final String title;

  /// Counter builder.
  final int Function(BuildContext context) countBuilder;

  /// Item for header.
  const SNSProfileHeaderItem(
      {@required this.onTap,
      @required this.title,
      @required this.countBuilder});
}
