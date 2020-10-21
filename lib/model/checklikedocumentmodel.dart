part of masamune.sns;

class CheckLikeDocumentModel extends FirestoreDocumentModel {
  final String likeId;
  final String userId;
  CheckLikeDocumentModel({@required String userId, @required String likeId})
      : this.likeId = likeId?.applyTags(),
        this.userId = userId?.applyTags(),
        super("user/$userId/like/$likeId");

  bool get isLike {
    if (isEmpty(likeId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == likeId;
  }
}
