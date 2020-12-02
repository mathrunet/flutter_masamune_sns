part of masamune.sns;

class UIBottomChat extends StatefulWidget {
  final bool enableImage;
  final void Function(
      BuildContext context, void Function(dynamic fileOrUrl) onUpdate) onImage;
  final void Function(BuildContext context, UIBottomChatData value) onPost;
  UIBottomChat({this.onPost, this.enableImage = false, this.onImage});

  @override
  State<StatefulWidget> createState() => _UIBottomChatState();
}

class _UIBottomChatState extends State<UIBottomChat> {
  TextEditingController _controller;
  File _data;
  String _path;

  @override
  void initState() {
    super.initState();
    this._controller = TextEditingController();
  }

  void _onUpdate(dynamic fileOrUrl) {
    if (fileOrUrl == null) return;
    if (fileOrUrl is String) {
      if (isEmpty(fileOrUrl)) return;
      this.setState(() {
        this._path = fileOrUrl;
        this._data = null;
      });
    } else if (fileOrUrl is File) {
      if (isEmpty(fileOrUrl.path)) return;
      this.setState(() {
        this._data = fileOrUrl;
        this._path = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = this._buildImage(context);
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          border: Border(
              top:
                  BorderSide(color: Theme.of(context).dividerColor, width: 1))),
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Stack(
          children: [
            TextFormField(
              controller: this._controller,
              keyboardType: TextInputType.text,
              maxLines: 5,
              minLines: 1,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.start,
              onFieldSubmitted: (value) {
                if (isEmpty(value)) return;
                this.widget.onPost?.call(
                    context,
                    UIBottomChatData._(
                        text: value, path: this._path, file: this._data));
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(image != null ? 80 : 20, 20,
                    this.widget.enableImage ? 85 : 55, 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: null,
                labelText: null,
                counterText: "",
              ),
            ),
            if (image != null) image,
            if (this.widget.enableImage)
              Positioned(
                right: 45,
                top: 0,
                bottom: 0,
                child: IconButton(
                  onPressed: () {
                    this.widget.onImage?.call(context, this._onUpdate);
                  },
                  padding: const EdgeInsets.only(bottom: 0),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.image,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: () {
                  this.widget.onPost?.call(
                      context,
                      UIBottomChatData._(
                          text: this._controller.text,
                          path: this._path,
                          file: this._data));
                },
                padding: const EdgeInsets.only(bottom: 0),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.send,
                  size: 25,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (this._data != null) {
      return Positioned(
          left: 10,
          top: 5,
          bottom: 5,
          width: 50,
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  height: 50,
                  width: 50,
                  child: InkWell(
                      onLongPress: () {
                        this.setState(() {
                          this._data = null;
                          this._path = null;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(this._data, fit: BoxFit.cover),
                      )))));
    } else if (this._path != null) {
      return Positioned(
          left: 10,
          top: 5,
          bottom: 5,
          width: 50,
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  height: 50,
                  width: 50,
                  child: InkWell(
                      onLongPress: () {
                        this.setState(() {
                          this._data = null;
                          this._path = null;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                            image: NetworkOrAsset.image(this._path),
                            fit: BoxFit.cover),
                      )))));
    }
    return null;
  }
}

class UIBottomChatData {
  final String text;
  final String _path;
  final File _data;
  String get path => this._path ?? this._data?.path;
  File get file => this._data;
  const UIBottomChatData._({this.text, String path, File file})
      : this._path = path,
        this._data = file;
}
