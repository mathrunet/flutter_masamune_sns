part of masamune.sns;

class BookmarkCollectionModel extends CollectionModel {
  final int limit;
  final String userId;
  final String target;
  BookmarkCollectionModel(
      {@required String userId, this.limit = 100, String target = "event"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/user/$userId/bookmark");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "user/$userId/bookmark",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    )
        .joinAt(
          path: this.path,
          key: "uid",
          builder: (col) {
            return FirestoreCollection.listen(
                "$target?bookmarkJoinedby=$userId",
                query: col.length <= 0
                    ? FirestoreQuery.empty()
                    : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
          },
        )
        .joinWhere(
          test: (original, additional) {
            return original.getString("streaming") == additional.uid;
          },
          prefix: "stream",
          builder: (col) {
            return FirestoreCollection.listen("stream",
                query: col.length <= 0
                    ? FirestoreQuery.empty()
                    : FirestoreQuery.inArray(
                        "uid", col.map((e) => e.getString("streaming"))));
          },
        );
  }

  Future like(String bookmarkId) async {
    if (isEmpty(bookmarkId) || isEmpty(userId) || isEmpty(target)) return;
    bookmarkId = bookmarkId.applyTags();
    final user = FirestoreDocument.create("user/$userId/bookmark/$bookmarkId");
    FirestoreDocument like =
        FirestoreDocument.create("$target/$bookmarkId/bookmarked/$userId");

    return Future.wait([
      user.save(),
      like.save(),
      FirestoreUtility.increment("$target/$bookmarkId/bookmarkedCount", 1)
    ]);
  }

  Future unlike(String bookmarkId) async {
    if (isEmpty(bookmarkId) || isEmpty(userId) || isEmpty(target)) return;
    bookmarkId = bookmarkId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/bookmark/$bookmarkId"),
      FirestoreDocument.deleteAt("$target/$bookmarkId/bookmarked/$userId"),
      FirestoreUtility.increment("$target/$bookmarkId/bookmarkedCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/bookmark",
      label: label?.localize(),
    );
  }
}
