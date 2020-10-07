part of masamune.sns;

@immutable
class LikedCollectionModel extends CollectionModel {
  final int limit;
  final String likeId;
  final String target;
  LikedCollectionModel(
      {@required String likeId, this.limit = 100, String target = "user"})
      : this.likeId = likeId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  Future<IDataCollection> createTask(ModelContext context) {
    String likeId = this.likeId?.applyTags();
    return FirestoreCollection.listen(
      "$target/$likeId/liked",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen("user?likeJoinedby=$likeId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  void dispose(Function(IDataCollection) rebuild) {
    PathMap.get<IDataCollection>("joined/$target/$likeId/liked")
        ?.unlisten(rebuild);
  }

  @override
  IDynamicCollection build(ModelContext context) {
    return PathMap.get<IDataCollection>("joined/$target/$likeId/liked");
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$likeId/liked",
      label: label?.localize(),
    );
  }
}
