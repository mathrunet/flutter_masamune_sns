part of masamune.sns;

class EntryCollectionModel extends CollectionModel {
  final int limit;
  final String userId;
  final String target;
  EntryCollectionModel(
      {@required String userId, this.limit = 100, String target = "event"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/user/$userId/entry");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "user/$userId/entry",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen("$target?entryJoinedby=$userId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  Future entry(String entryId) async {
    if (isEmpty(entryId) || isEmpty(userId) || isEmpty(target)) return;
    entryId = entryId.applyTags();
    final user = FirestoreDocument.create("user/$userId/entry/$entryId");
    FirestoreDocument entry =
        FirestoreDocument.create("$target/$entryId/entry/$userId");

    return Future.wait([
      user.save(),
      entry.save(),
      FirestoreUtility.increment("$target/$entryId/entryCount", 1)
    ]);
  }

  Future exit(String entryId) async {
    if (isEmpty(entryId) || isEmpty(userId) || isEmpty(target)) return;
    entryId = entryId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/entry/$entryId"),
      FirestoreDocument.deleteAt("$target/$entryId/entry/$userId"),
      FirestoreUtility.increment("$target/$entryId/entryCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/entry",
      label: label?.localize(),
    );
  }
}
