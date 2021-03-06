part of masamune.sns;

class FollowCollecionModel extends CollectionModel {
  final int limit;
  final String userId;
  FollowCollecionModel({@required String userId, this.limit = 100})
      : this.userId = userId?.applyTags(),
        super("joined/user/$userId/follow");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "user/$userId/follow",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen(
          "user?followJoinedby=$userId",
          query: col.length <= 0
              ? FirestoreQuery.empty()
              : FirestoreQuery.inArray(
                  "uid",
                  col.map((e) => e.uid),
                ),
        );
      },
    );
  }

  Future follow(String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    final followDoc = FirestoreDocument.create("user/$userId/follow/$followId");
    FirestoreDocument followerDoc =
        FirestoreDocument.create("user/$followId/follower/$userId");

    return Future.wait([
      followDoc.save(),
      followerDoc.save(),
      FirestoreUtility.increment("user/$followId/followerCount", 1),
      FirestoreUtility.increment("user/$userId/followCount", 1)
    ]);
  }

  Future unfollow(String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$followId/follower/$userId"),
      FirestoreDocument.deleteAt("user/$userId/follow/$followId"),
      FirestoreUtility.increment("user/$followId/followerCount", -1),
      FirestoreUtility.increment("user/$userId/followCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/follow",
      label: label?.localize(),
    );
  }
}
