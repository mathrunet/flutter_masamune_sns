part of masamune.sns;

class CheckBlockDocumentModel extends FirestoreDocumentModel {
  final String blockId;
  final String userId;
  CheckBlockDocumentModel({@required String userId, @required String blockId})
      : this.blockId = blockId?.applyTags(),
        this.userId = userId?.applyTags(),
        super("user/$userId/block/$blockId");

  bool get isBlocked {
    if (isEmpty(blockId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == blockId;
  }
}
