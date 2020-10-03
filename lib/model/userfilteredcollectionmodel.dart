part of masamune.sns;

@immutable
class UserFilteredCollectionModel extends CollectionModel {
  final String target;
  final String userId;
  final OrderBy orderBy;
  final String orderByKey;
  final int limit;
  UserFilteredCollectionModel(
      {@required String target,
      @required String userId,
      this.limit = 100,
      this.orderBy = OrderBy.desc,
      this.orderByKey = "date"})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  Future createTask() {
    return FirestoreCollection.listen(
      "$target?filteredBy=$userId",
      orderBy: this.orderBy,
      orderByKey: this.orderByKey,
      query: this.orderBy == OrderBy.desc
          ? FirestoreQuery.equalTo("user", userId)
              .orderByDesc(this.orderByKey)
              .limitAt(this.limit)
          : FirestoreQuery.equalTo("user", userId)
              .orderByAsc(this.orderByKey)
              .limitAt(this.limit),
    );
  }

  @override
  Iterable<IDataDocument> build(ModelContext context) {
    return PathMap.get<IDataCollection>("$target?filteredBy=$userId");
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target?filteredBy=$userId",
      label: label?.localize(),
    );
  }
}
