part of masamune.sns;

class CheckFollowDocumentModel extends DocumentModel {
  final String followId;
  final String userId;
  CheckFollowDocumentModel({String userId, String followId})
      : this.followId = followId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();

  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("user/$userId/follow/$followId");
  }

  bool get isFolllow {
    if (isEmpty(followId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == followId;
  }
}
