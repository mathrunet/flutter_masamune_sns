part of masamune.sns;

@immutable
class UserFilteredDocumentModel extends DocumentModel {
  final String target;
  final String eventId;
  final String prefix;
  UserFilteredDocumentModel(
      {@required String target, @required String eventId, this.prefix = "user"})
      : this.target = target?.applyTags(),
        this.eventId = eventId?.applyTags(),
        super();

  @override
  Future createTask() {
    return FirestoreDocument.listen("$target/$eventId").joinAt(
      prefix: this.prefix,
      builder: (doc) {
        return FirestoreDocument.listen("user/${doc.getString("user")}");
      },
    );
  }

  @override
  IDynamicalDataMap build(ModelContext context) {
    return PathMap.get<IDataDocument>("$target/$eventId");
  }
}
