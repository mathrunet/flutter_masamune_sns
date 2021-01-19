part of masamune.sns;

class TimelineDocumentModel extends DocumentModel {
  final String userId;
  final String userKey;
  final String target;
  final String prefix;
  final String timelineId;
  TimelineDocumentModel(
      {@required String userId,
      @required String timelineId,
      String prefix = "user",
      String userKey = "user",
      String target = "timeline"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        this.timelineId = timelineId?.applyTags(),
        this.userKey = userKey?.applyTags(),
        this.prefix = prefix,
        super("joined/$target/$timelineId");

  @override
  Future<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen(
      "$target/$timelineId",
    )
        .joinAt(
      path: this.path,
      builder: (document) async {
        return FirestoreDocument.listen(
            "user/${document.getString(this.userKey)}");
      },
      prefix: this.prefix,
    )
        .joinAt(
      builder: (document) async {
        return FirestoreDocument.listen("user/$userId/like/${document.uid}");
      },
      onApply: (original, additional) {
        if (additional == null || additional.length <= 0) {
          original["liked"] = false;
        } else {
          original["liked"] = true;
        }
      },
    );
  }
}
