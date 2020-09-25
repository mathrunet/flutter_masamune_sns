part of masamune.sns;

class CheckEntryDocumentModel extends DocumentModel {
  final String entryId;
  final String userId;
  CheckEntryDocumentModel({String userId, String entryId})
      : this.entryId = entryId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();
  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("user/$userId/entry/$entryId");
  }

  bool get isEntried {
    if (isEmpty(entryId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == entryId;
  }
}
