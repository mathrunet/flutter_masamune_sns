part of masamune.sns;

class CheckBlockedDocumentModel extends FirestoreDocumentModel {
  final String blockId;
  final String userId;
  final String target;
  CheckBlockedDocumentModel(
      {@required String userId,
      @required String blockId,
      String target = "user"})
      : this.blockId = blockId?.applyTags(),
        this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super("$target/$blockId/blocked/$userId");

  bool get isBlocked {
    if (isEmpty(blockId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == userId;
  }
}
