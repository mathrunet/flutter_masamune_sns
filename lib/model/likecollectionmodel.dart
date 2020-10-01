part of masamune.sns;

@immutable
class LikeCollectionModel extends CollectionModel {
  final int limit;
  final String userId;
  final String target;
  LikeCollectionModel(
      {@required String userId, this.limit = 100, String target = "user"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  Future<IPath> createTask() {
    return FirestoreCollection.listen(
      "user/$userId/like",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen("$target?likeJoinedby=$userId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  Future like(String likeId) async {
    if (isEmpty(likeId) || isEmpty(userId) || isEmpty(target)) return;
    likeId = likeId.applyTags();
    final user = FirestoreDocument.create("user/$userId/like/$likeId");
    FirestoreDocument like =
        FirestoreDocument.create("$target/$likeId/liked/$userId");

    return Future.wait([
      user.save(),
      like.save(),
      SNSUtility._increment("$target/$likeId/likedCount", 1)
    ]);
  }

  @override
  Iterable<IDataDocument<IDataField>> build() {
    return PathMap.get<IDataCollection>("joined/user/$userId/like");
  }

  Future unlike(String likeId) async {
    if (isEmpty(likeId) || isEmpty(userId) || isEmpty(target)) return;
    likeId = likeId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/like/$likeId"),
      FirestoreDocument.deleteAt("$target/$likeId/liked/$userId"),
      SNSUtility._increment("$target/$likeId/likedCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/like",
      label: label?.localize(),
    );
  }
}