part of masamune.sns;

class CheckLikeDocument extends DocumentModel {
  final String likeId;
  final String userId;
  CheckLikeDocument({String userId, String likeId})
      : this.likeId = likeId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();
  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("user/$userId/like/$likeId");
  }

  bool isLike(BuildContext context) {
    if (context == null || isEmpty(likeId) || isEmpty(userId)) return false;
    return context.watch<String>("${this.context.path}/uid") == likeId;
  }
}
