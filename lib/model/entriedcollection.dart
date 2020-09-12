part of masamune.sns;

class EntriedCollection extends CollectionModel {
  final int limit;
  final String entryId;
  final String target;
  EntriedCollection({String entryId, this.limit = 100, String target = "event"})
      : this.entryId = entryId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  FutureOr<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen("$target/$entryId/entry",
            query: FirestoreQuery.orderByDesc("time").limitAt(this.limit))
        .joinAt(
            key: "uid",
            builder: (col) {
              return FirestoreCollection.listen("user?entryJoinedby=$entryId",
                  query: col.length <= 0
                      ? FirestoreQuery.empty()
                      : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
            });
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$entryId/entry",
      label: label?.localize(),
    );
  }
}
