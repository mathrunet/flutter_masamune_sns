part of masamune.sns;

class CheckLikeDocumentModel extends DocumentModel {
  final String likeId;
  final String userId;
  CheckLikeDocumentModel({String userId, String likeId})
      : this.likeId = likeId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();
  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("user/$userId/like/$likeId");
  }

  bool get isLike {
    if (isEmpty(likeId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == likeId;
  }
}
