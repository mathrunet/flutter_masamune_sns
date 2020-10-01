part of masamune.sns;

@immutable
class CheckLikeDocumentModel extends DocumentModel {
  final String likeId;
  final String userId;
  CheckLikeDocumentModel({@required String userId, @required String likeId})
      : this.likeId = likeId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();
  @override
  IDynamicalDataMap build() {
    return FirestoreDocumentModel("user/$userId/like/$likeId");
  }

  bool get isLike {
    if (isEmpty(likeId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null || state.containsKey("uid")) return false;
    return state["uid"] == likeId;
  }
}
