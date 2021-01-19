part of masamune.sns;

class BlockCollectionModel extends CollectionModel {
  final int limit;
  final String userId;
  final String target;
  BlockCollectionModel(
      {@required String userId, this.limit = 100, String target = "user"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/user/$userId/block");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "user/$userId/block",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen("$target?reportJoinedby=$userId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  Future block(String blockId) async {
    if (isEmpty(blockId) || isEmpty(userId) || isEmpty(target)) return;
    blockId = blockId.applyTags();
    final user = FirestoreDocument.create("$target/$blockId/blocked/$userId");
    FirestoreDocument block =
        FirestoreDocument.create("user/$userId/block/$blockId");

    return Future.wait([
      user.save(),
      block.save(),
    ]);
  }

  Future unblock(String blockId) async {
    if (isEmpty(blockId) || isEmpty(userId) || isEmpty(target)) return;
    blockId = blockId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/block/$blockId"),
      FirestoreDocument.deleteAt("$target/$blockId/blocked/$userId"),
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/block",
      label: label?.localize(),
    );
  }
}
