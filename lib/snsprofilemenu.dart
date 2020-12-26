part of masamune.sns;

/// Created a small menu for social networking profiles.
class SNSProfileMenu extends StatelessWidget {
  final String reportLabel;

  final String blockLabel;

  final String blockConfirmText;

  final String blockConfirmTitle;

  final String blockSubmitText;
  final String blockCancelText;

  final String blockCompletedText;

  final String blockCompletedTitle;

  final String reportCompletedText;

  final String reportCompletedTitle;

  final Future Function() onReport;

  final Future Function() onBlock;

  /// Created a small menu for social networking profiles.
  SNSProfileMenu(
      {this.reportLabel = "Report",
      this.reportCompletedTitle = "Success",
      this.reportCompletedText = "You have reported this user.",
      this.onReport,
      this.blockLabel = "Block",
      this.blockConfirmTitle = "Confirmation",
      this.blockConfirmText = "You will block this user. Are you sure?",
      this.blockCompletedTitle = "Success",
      this.blockCompletedText = "You have blocked this user.",
      this.blockSubmitText = "Yes",
      this.blockCancelText = "No",
      this.onBlock});

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: (String s) async {
        switch (s) {
          case "report":
            await this.onReport?.call();
            UIDialog.show(
              context,
              title: this.reportCompletedTitle.localize(),
              text: this.reportCompletedText.localize(),
            );
            break;
          case "block":
            UIConfirm.show(context,
                title: this.blockConfirmTitle.localize(),
                text: this.blockConfirmText.localize(),
                submitText: this.blockSubmitText.localize(),
                onSubmit: () async {
              await this.onBlock?.call();
              UIDialog.show(context,
                  title: this.blockCompletedTitle.localize(),
                  text: this.blockCompletedText.localize(), onSubmit: () async {
                context.navigator.pop();
              });
            }, cacnelText: this.blockCancelText.localize());
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text(this.reportLabel.localize()),
            value: "report",
          ),
          PopupMenuItem(
            child: Text(this.blockLabel.localize()),
            value: "block",
          ),
        ];
      },
    );
  }
}
