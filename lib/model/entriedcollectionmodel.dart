part of masamune.sns;

class EntriedCollectionModel extends CollectionModel {
  final int limit;
  final String entryId;
  final String target;
  EntriedCollectionModel(
      {@required String entryId, this.limit = 100, String target = "event"})
      : this.entryId = entryId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  Future<IDataCollection> createTask(ModelContext context) {
    return FirestoreCollection.load(
      "$target/$entryId/entry",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: "joined/$target/$entryId/entry",
      key: "uid",
      builder: (col) {
        return FirestoreCollection.load("user?entryJoinedby=$entryId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  @override
  IDynamicCollection build(ModelContext context) {
    return PathMap.get<IDataCollection>("joined/$target/$entryId/entry");
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$entryId/entry",
      label: label?.localize(),
    );
  }
}
