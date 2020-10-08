part of masamune.sns;

class EntriedCollectionModel extends CollectionModel {
  final int limit;
  final String entryId;
  final String target;
  EntriedCollectionModel(
      {@required String entryId, this.limit = 100, String target = "event"})
      : this.entryId = entryId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/$target/$entryId/entry");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.load(
      "$target/$entryId/entry",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      builder: (col) {
        return FirestoreCollection.load("user?entryJoinedby=$entryId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$entryId/entry",
      label: label?.localize(),
    );
  }
}
