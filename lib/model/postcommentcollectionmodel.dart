part of masamune.sns;

class PostCommentCollectionModel extends CollectionModel {
  final int limit;
  final String postId;
  final String prefix;
  final String target;
  PostCommentCollectionModel(
      {@required String postId,
      this.prefix = "user",
      this.limit = 100,
      String target = "timeline"})
      : this.postId = postId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/$target/$postId/comment");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "$target/$postId/comment",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      prefix: this.prefix,
      builder: (col) {
        return FirestoreCollection.listen(
          "user?commentJoinedby=$userId",
          query: col.length <= 0
              ? FirestoreQuery.empty()
              : FirestoreQuery.inArray(
                  "uid",
                  col.map((e) => e.getString("user")),
                ),
        );
      },
    );
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$postId/comment",
      label: label?.localize(),
    );
  }
}
