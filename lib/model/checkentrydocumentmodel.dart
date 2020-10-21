part of masamune.sns;

class CheckEntryDocumentModel extends FirestoreDocumentModel {
  final String entryId;
  final String userId;
  CheckEntryDocumentModel({@required String userId, @required String entryId})
      : this.entryId = entryId?.applyTags(),
        this.userId = userId?.applyTags(),
        super("user/$userId/entry/$entryId");

  bool get isEntried {
    if (isEmpty(entryId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == entryId;
  }
}
