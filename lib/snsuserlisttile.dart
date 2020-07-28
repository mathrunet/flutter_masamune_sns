part of masamune.sns;

/// Create a user list tile for SNS.
class SNSUserListTile extends StatelessWidget {
  /// Create a user list tile for SNS.
  SNSUserListTile(
      {@required this.name,
      @required this.icon,
      this.buttonColor,
      this.buttonText = "Follow",
      this.onPressed,
      this.onButtonPressed,
      this.showButton = true});

  /// Color for buttons such as follow.
  final Color buttonColor;

  /// Text for buttons such as follow.
  final String buttonText;

  /// User name.
  final String name;

  /// Icon for the user.
  final Widget icon;

  /// True to display the button.
  final bool showButton;

  /// What happens when a tile is tapped.
  final VoidAction onPressed;

  /// Processing when a button such as follow is tapped.
  final VoidAction onButtonPressed;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 40, height: 40, child: this.icon),
      title: Text(this.name),
      trailing: FlatButton.icon(
        shape: StadiumBorder(),
        icon: Icon(Icons.person_add, color: Colors.white),
        onPressed: this.onButtonPressed,
        label: Text(this.buttonText.localize(),
            style: TextStyle(color: Colors.white)),
        color: this.buttonColor ?? context.theme.accentColor,
      ),
      onTap: this.onPressed,
    );
  }
}
