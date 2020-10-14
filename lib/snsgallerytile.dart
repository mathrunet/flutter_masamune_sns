part of masamune.sns;

class SNSGalleryTile extends StatelessWidget {
  final Function onTap;
  final ImageProvider image;
  final Color backgroundColor;
  final double height;
  final Color likeBackgroundColor;
  final Color likeColor;
  final int likeCount;
  final bool enableLike;
  final Function onLike;
  SNSGalleryTile(
      {this.onTap,
      this.onLike,
      this.backgroundColor,
      @required this.image,
      this.height = 100,
      this.enableLike = true,
      this.likeBackgroundColor,
      this.likeColor,
      this.likeCount = 0});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: this.backgroundColor ?? Theme.of(context).disabledColor,
          ),
          Image(
            image: this.image,
            height: this.height,
            fit: BoxFit.cover,
          ),
          if (this.enableLike)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                width: 45,
                height: 20,
                child: RaisedButton.icon(
                  elevation: 4,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    this.onLike?.call();
                  },
                  shape: const StadiumBorder(),
                  color: this.likeBackgroundColor ??
                      Theme.of(context).backgroundColor.withOpacity(1),
                  icon: Icon(FontAwesomeIcons.solidHeart,
                      size: 12,
                      color: this.likeColor ?? Theme.of(context).primaryColor),
                  label: Text(
                    this.likeCount.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            this.likeColor ?? Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
