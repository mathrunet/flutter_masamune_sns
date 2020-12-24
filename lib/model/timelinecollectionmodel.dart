part of masamune.sns;

@immutable
class TimelineCollectionModel extends CollectionModel {
  final String targetUserId;
  final String userId;
  final String target;
  final int limit;
  final String prefix;
  final String sortKey;
  TimelineCollectionModel(
      {@required String targetUserId,
      @required String userId,
      String sortKey = "time",
      String prefix = "user",
      String target = "timeline",
      this.limit = 100})
      : this.userId = userId?.applyTags(),
        this.targetUserId = userId?.applyTags(),
        this.target = target?.applyTags(),
        this.sortKey = sortKey,
        this.prefix = prefix,
        super("joined/$target?filteredBy=$targetUserId");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "$target?filteredBy=$targetUserId",
      query: FirestoreQuery.equalTo("user", targetUserId)
          .orderByDesc(this.sortKey)
          .limitAt(this.limit),
    )
        .joinDocumentWhere(
          path: this.path,
          test: (newField, oldField) {
            return oldField.getString("uid") == newField.getString("user");
          },
          builder: (collection) async {
            return FirestoreDocument.listen("user/$targetUserId");
          },
          prefix: this.prefix,
        )
        .joinWhere(
          path: this.path,
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
        .joinWhere(
          path: this.path,
          test: (original, additional) {
            return additional.uid == original.uid;
          },
          builder: (collection) {
            return FirestoreCollection.listen(
              "user/$userId/report?${target}Joined",
              query: collection.length <= 0
                  ? FirestoreQuery.empty()
                  : FirestoreQuery.inArray(
                      "uid",
                      collection.map((e) => e.uid),
                    ),
            );
          },
          onFound: (key, value, document, collection) {
            value["report"] = true;
          },
          onNotFound: (key, value, collection) {
            value["report"] = false;
          },
        );
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target?filteredBy=$targetUserId",
      label: label?.localize(),
    );
  }
}
