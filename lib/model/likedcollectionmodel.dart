part of masamune.sns;

class LikedCollectionModel extends CollectionModel {
  final int limit;
  final String likeId;
  final String target;
  LikedCollectionModel(
      {@required String likeId, this.limit = 100, String target = "user"})
      : this.likeId = likeId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/$target/$likeId/liked");

  @override
  Future<IDataCollection> build(ModelContext context) {
    String likeId = this.likeId?.applyTags();
    return FirestoreCollection.listen(
      "$target/$likeId/liked",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen("user?likeJoinedby=$likeId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$likeId/liked",
      label: label?.localize(),
    );
  }
}
