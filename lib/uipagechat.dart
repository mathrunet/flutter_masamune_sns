part of masamune.sns;

/// Template for creating chat pages.
abstract class UIPageChat extends UIPageScaffold
    with UITextFieldControllerMixin {
  /// Executed when the widget is loaded.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  @mustCallSuper
  void onLoad(BuildContext context) {
    super.onLoad(context);
    this.init({"text": Const.empty});
  }

  /// What happens when a message is posted.
  ///
  /// [context]: Build context.
  /// [value]: Text value.
  void onPost(BuildContext context, String value);

  /// Message list.
  ///
  /// [context]: Build context.
  List<Widget> messageBody(BuildContext context);

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget body(BuildContext context) {
    return Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          UIBottomChat(
            onPost: this.onPost,
          ),
          Expanded(
            child: ListView(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: this.messageBody(context)),
          ),
        ]);
  }
}
