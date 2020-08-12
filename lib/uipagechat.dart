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
    this.init(initial: {"text": Const.empty});
  }

  /// What happens when a message is posted.
  ///
  /// [context]: Build context.
  void onPost(BuildContext context);

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
          Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: context.theme.dividerColor, width: 1))),
              child: Container(
                  color: context.theme.backgroundColor,
                  child: Stack(children: [
                    TextFormField(
                      controller: this.controllers["text"],
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      minLines: 1,
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 55, 20),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: null,
                        labelText: null,
                        counterText: "",
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                          onPressed: () => this.onPost(context),
                          padding: const EdgeInsets.only(bottom: 0),
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.send,
                            size: 25,
                            color: context.theme.disabledColor,
                          )),
                    )
                  ]))),
          Expanded(
            child: ListView(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: this.messageBody(context)),
          ),
        ]);
  }
}
