part of masamune.sns;

@immutable
class CheckFollowDocumentModel extends DocumentModel {
  final String followId;
  final String userId;
  CheckFollowDocumentModel({@required String userId, @required String followId})
      : this.followId = followId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();

  @override
  IDynamicalDataMap build() {
    return FirestoreDocumentModel("user/$userId/follow/$followId");
  }

  bool get isFolllow {
    if (isEmpty(followId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null || state.containsKey("uid")) return false;
    return state["uid"] == followId;
  }
}
