part of masamune.sns;

class CheckFollowDocument extends DocumentModel {
  final String followId;
  final String userId;
  CheckFollowDocument({String userId, String followId})
      : this.followId = followId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();

  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("user/$userId/follow/$followId");
  }

  bool isFolllow(BuildContext context) {
    if (context == null || isEmpty(followId) || isEmpty(userId)) return false;
    return context.watch<String>("${this.context.path}/uid") == followId;
  }
}
