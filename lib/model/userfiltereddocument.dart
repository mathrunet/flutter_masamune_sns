part of masamune.sns;

class UserFilteredDocument extends DocumentModel {
  final String target;
  final String eventId;
  final String prefix;
  UserFilteredDocument({String target, String eventId, this.prefix = "user"})
      : this.target = target?.applyTags(),
        this.eventId = eventId?.applyTags(),
        super();

  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("$target/$eventId").joinAt(
        prefix: this.prefix,
        builder: (doc) {
          return FirestoreDocument.listen("user/${doc.getString("user")}");
        });
  }
}
