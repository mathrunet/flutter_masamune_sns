part of masamune.sns;

class UserFilteredDocumentModel extends DocumentModel {
  final String target;
  final String eventId;
  final String prefix;
  UserFilteredDocumentModel(
      {@required String target, @required String eventId, this.prefix = "user"})
      : this.target = target?.applyTags(),
        this.eventId = eventId?.applyTags(),
        super("joined/$target/$eventId");

  @override
  Future<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("$target/$eventId").joinAt(
      path: this.path,
      prefix: this.prefix,
      builder: (doc) {
        return FirestoreDocument.listen("user/${doc.getString("user")}");
      },
    );
  }
}
