part of masamune.sns;

@immutable
class HomeTimelineCollectionModel extends CollectionModel {
  final String userId;
  final String target;
  final int limit;
  final String prefix;
  final String sortKey;
  HomeTimelineCollectionModel(
      {@required String userId,
      String target = "timeline",
      String sortKey = "time",
      this.limit = 100,
      this.prefix = "user"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        this.sortKey = sortKey?.applyTags(),
        super();

  @override
  Future<IPath> createTask() async {
    final follow =
        await FirestoreCollection.listen("user/$userId/follow").joinAt(
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen(
          "user?followJoinedby=$userId",
          query: col.length <= 0
              ? FirestoreQuery.empty()
              : FirestoreQuery.inArray(
                  "uid",
                  col.map((e) => e.uid),
                ),
        );
      },
    );
    return await FirestoreCollection.listen(
      "$target?homeFilteredBy=$userId",
      query: FirestoreQuery.inArray(
              "user", follow.map((e) => e.uid).toList()..add(userId))
          .orderByDesc(this.sortKey)
          .limitAt(this.limit),
    )
        .joinWhere(
          path: "joined/$target?homeFilteredBy=$userId",
          test: (newField, oldField) {
            return oldField.getString("uid") == newField.getString("user");
          },
          builder: (collection) async {
            return follow;
          },
          prefix: this.prefix,
        )
        .joinWhere(
          path: "joined/$target?homeFilteredBy=$userId",
          test: (original, additional) {
            return additional.uid == original.uid;
          },
          builder: (collection) {
            return FirestoreCollection.listen(
              "user/$userId/like?${target}Joined",
              query: collection.length <= 0
                  ? FirestoreQuery.empty()
                  : FirestoreQuery.inArray(
                      "uid",
                      collection.map((e) => e.uid),
                    ),
            );
          },
          onFound: (key, value, document, collection) {
            value["liked"] = true;
          },
          onNotFound: (key, value, collection) {
            value["liked"] = false;
          },
        )
        .joinDocumentWhere(
          path: "joined/$target?homeFilteredBy=$userId",
          test: (newField, oldField) {
            return oldField.getString("uid") == newField.getString("user");
          },
          builder: (collection) async {
            return FirestoreDocument.listen("user/$userId");
          },
          prefix: this.prefix,
        );
  }

  @override
  Iterable<IDataDocument> build() {
    return PathMap.get<IDataCollection>(
        "joined/$target?homeFilteredBy=$userId");
  }

  Widget loadNext(String label) {
    String target = this.target?.applyTags();
    return LoadNext(
      path: "$target?homeFilteredBy=$userId",
      label: label?.localize(),
    );
  }
}
