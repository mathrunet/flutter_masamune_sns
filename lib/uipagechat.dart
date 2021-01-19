part of masamune.sns;

/// Template for creating chat pages.
abstract class UIPageChat extends UIPageScaffold {
  /// What happens when a message is posted.
  ///
  /// [context]: Build context.
  /// [value]: UIBottomChatData value.
  void onPost(BuildContext context, UIBottomChatData value);

  /// If you want to enable the posting of images True.
  bool get enableImage => false;

  /// The process of adding an image.
  ///
  /// [context]: Build context.
  /// [value]: Callback for loading a file.
  void onImage(
      BuildContext context, void Function(dynamic fileOrUrl) onUpdate) {}

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
            enableImage: this.enableImage,
            onImage: this.onImage,
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
