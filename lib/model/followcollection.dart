part of masamune.sns;

class FollowCollecion extends CollectionModel {
  final int limit;
  final String userId;
  FollowCollecion({String userId, this.limit = 100})
      : this.userId = userId?.applyTags(),
        super();

  @override
  FutureOr<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen("user/$userId/follow",
            query: FirestoreQuery.orderByDesc("time").limitAt(this.limit))
        .joinAt(
            key: "uid",
            builder: (col) {
              return FirestoreCollection.listen("user?followJoinedby=$userId",
                  query: col.length <= 0
                      ? FirestoreQuery.empty()
                      : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
            });
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
      SNSUtility._increment("user/$followId/followerCount", 1),
      SNSUtility._increment("user/$userId/followCount", 1)
    ]);
  }

  Future unfollow(String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$followId/follower/$userId"),
      FirestoreDocument.deleteAt("user/$userId/follow/$followId"),
      SNSUtility._increment("user/$followId/followerCount", -1),
      SNSUtility._increment("user/$userId/followCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/follow",
      label: label?.localize(),
    );
  }
}
