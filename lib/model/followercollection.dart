part of masamune.sns;

class FollowerCollection extends CollectionModel {
  final int limit;
  final String userId;
  FollowerCollection({String userId, this.limit = 100})
      : this.userId = userId?.applyTags(),
        super();

  @override
  FutureOr<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen("user/$userId/follower",
            query: FirestoreQuery.orderByDesc("time").limitAt(this.limit))
        .joinAt(
            key: "uid",
            builder: (col) {
              return FirestoreCollection.listen("user?followerJoinedby=$userId",
                  query: col.length <= 0
                      ? FirestoreQuery.empty()
                      : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
            })
        .joinAt(
          key: "uid",
          builder: (col) {
            return FirestoreCollection.listen(
                "user/[UID]/follow?folllowerJoinedby=$userId",
                query: col.length <= 0
                    ? FirestoreQuery.empty()
                    : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
          },
          onFound: (key, value, document, collection) {
            value["follow"] = true;
          },
          onNotFound: (key, value, collection) {
            value["follow"] = false;
          },
        );
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/follower",
      label: label?.localize(),
    );
  }
}
