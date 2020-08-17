part of masamune.sns;

/// SNS profile header.
class SNSProfileHeader extends StatelessWidget {
  /// Builder for getting images.
  final ImageProvider Function(BuildContext context) imageBuilder;

  /// Builder to get the name.
  final String Function(BuildContext context) nameBuilder;

  /// Builder for getting text.
  final String Function(BuildContext context) textBuilder;

  /// Name postfix.
  final String namePostfix;

  /// Header item.
  final List<SNSProfileHeaderItem> items;

  /// SNS profile header.
  SNSProfileHeader(
      {this.imageBuilder,
      this.items,
      @required this.nameBuilder,
      @required this.textBuilder,
      this.namePostfix = ""})
      : assert(nameBuilder != null),
        assert(textBuilder != null);

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    String name = this.nameBuilder(context);
    String text = this.textBuilder(context);
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
        if (isNotEmpty(name) || isNotEmpty(text))
          Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 20),
              child: UIText((context) => "$name $namePostfix\n"
                  "$text")),
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
