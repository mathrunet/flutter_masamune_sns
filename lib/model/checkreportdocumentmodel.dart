part of masamune.sns;

class CheckReportDocumentModel extends FirestoreDocumentModel {
  final String postId;
  final String userId;
  CheckReportDocumentModel({@required String userId, @required String postId})
      : this.postId = postId?.applyTags(),
        this.userId = userId?.applyTags(),
        super("user/$userId/report/$postId");

  bool get isReported {
    if (isEmpty(postId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == postId;
  }
}
