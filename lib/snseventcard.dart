part of masamune.sns;

/// SNS event card.
class SNSEventCard extends StatelessWidget {
  /// Image of the event.
  final ImageProvider image;

  /// Image height.
  final double imageHeight;

  /// Event title.
  final String title;

  /// Date format.
  final DateFormat dateFormat;

  /// Date data.
  final DateTime date;

  /// Overview.
  final String text;

  /// Elevation.
  final double elevation;

  /// SNS event card.
  ///
  /// [image]: Image of the event.
  /// [imageHeight]: Image height.
  /// [title]: Event title.
  /// [dateFormat]: Date format.
  /// [date]: Date data.
  /// [text]: Overview.
  /// [elevation]: Elevation.
  SNSEventCard(
      {this.image,
      this.elevation = 8.0,
      this.imageHeight,
      @required this.title,
      this.dateFormat,
      this.date,
      this.text})
      : assert(isNotEmpty(title));

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: this.elevation,
        child: Column(
          children: [
            if (this.image != null)
              ConstrainedBox(
                  constraints: BoxConstraints.expand(height: this.imageHeight),
                  child: Image(image: this.image, fit: BoxFit.cover)),
            ListTile(
              title: Text(this.title ?? Const.empty),
              trailing: this.date != null
                  ? Text(
                      (this.dateFormat ?? DateFormat("yyyy/MM/dd(E)\nHH:mm"))
                          .format(this.date),
                      style: TextStyle(
                          color: context.theme.disabledColor, fontSize: 10),
                      textAlign: TextAlign.right)
                  : null,
              subtitle: Text(this.text ?? Const.empty),
              isThreeLine: true,
            ),
            Space.height(5)
          ],
        ));
  }
}
