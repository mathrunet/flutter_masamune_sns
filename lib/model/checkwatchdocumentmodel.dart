part of masamune.sns;

class CheckWatchDocumentModel extends FirestoreDocumentModel {
  final String watchId;
  final String userId;
  final String target;
  CheckWatchDocumentModel(
      {@required String userId,
      @required String watchId,
      String target = "stream"})
      : this.watchId = watchId?.applyTags(),
        this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super("user/$userId/watch/$watchId");

  bool get isWatch {
    if (isEmpty(watchId) || isEmpty(userId)) return false;
    final state = this.state;
    if (state == null) return false;
    return state.uid == watchId;
  }

  Future watch() async {
    if (isEmpty(watchId) || isEmpty(userId) || isEmpty(target)) return;
    final check = await FirestoreDocument.listen("user/$userId/watch/$watchId");
    if (check != null && check.length > 0) return;
    final user = FirestoreDocument.create("user/$userId/watch/$watchId");
    FirestoreDocument watch =
        FirestoreDocument.create("$target/$watchId/watched/$userId");

    return Future.wait([
      user.save(),
      watch.save(),
      FirestoreUtility.increment("$target/$watchId/watchedCount", 1),
      FirestoreUtility.increment("user/$userId/watchCount", 1)
    ]);
  }
}
