part of masamune.sns;

class CheckEntryDocumentModel extends DocumentModel {
  final String entryId;
  final String userId;
  CheckEntryDocumentModel({@required String userId, @required String entryId})
      : this.entryId = entryId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();
  @override
  IDynamicalDataMap build() {
    return FirestoreDocumentModel("user/$userId/entry/$entryId");
  }

  bool get isEntried {
    if (isEmpty(entryId)) return false;
    final state = this.state;
    if (state == null || !state.containsKey("uid")) return false;
    return state["uid"] == entryId;
  }
}
