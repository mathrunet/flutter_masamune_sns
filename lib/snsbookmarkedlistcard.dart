part of masamune.sns;

class SNSBookmarkedListCard extends StatelessWidget {
  final Function onTap;

  final ImageProvider image;

  final double height;

  final Widget title;

  final String buttonTitle;

  final Function onButtonTap;

  final IconData icon;

  final Function onIconTap;

  final double elevation;

  final EdgeInsetsGeometry margin;

  SNSBookmarkedListCard(
      {this.onTap,
      this.image,
      this.margin,
      this.elevation = 8,
      this.icon,
      this.onIconTap,
      this.height = 160,
      this.title,
      this.buttonTitle,
      this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.onTap,
        child: Card(
          margin: this.margin ?? const EdgeInsets.symmetric(vertical: 10),
          elevation: this.elevation,
          child: Column(
            children: [
              Container(
                  constraints: BoxConstraints.expand(height: this.height),
                  child: Image(
                    image: this.image,
                    fit: BoxFit.cover,
                  )),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: this.title),
                      if (isNotEmpty(this.buttonTitle)) ...[
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: context.theme.accentColor,
                          visualDensity: VisualDensity.compact,
                          child: Text(this.buttonTitle.localize(),
                              style: TextStyle(
                                  color: context.theme.backgroundColor)),
                          onPressed: this.onButtonTap,
                        ),
                      ],
                      if (this.icon != null) ...[
                        SizedBox(width: 15),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.all(0),
                          constraints: BoxConstraints(),
                          icon:
                              Icon(this.icon, color: context.theme.accentColor),
                          onPressed: this.onIconTap,
                        )
                      ]
                    ],
                  ))
            ],
          ),
        ));
  }
}
