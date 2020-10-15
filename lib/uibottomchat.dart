part of masamune.sns;

class UIBottomChat extends HookWidget {
  final void Function(BuildContext context, String value) onPost;
  UIBottomChat({this.onPost});
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

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
              controller: controller,
              keyboardType: TextInputType.text,
              maxLines: 5,
              minLines: 1,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.start,
              onFieldSubmitted: (value) {
                if (isEmpty(value)) return;
                this.onPost?.call(context, value);
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 55, 20),
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
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: () {
                  this.onPost?.call(context, controller.text);
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
}
