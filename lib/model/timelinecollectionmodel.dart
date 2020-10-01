part of masamune.sns;

@immutable
class TimelineCollectionModel extends CollectionModel {
  final String userId;
  final String target;
  final int limit;
  TimelineCollectionModel(
      {@required String userId, String target = "timeline", this.limit = 100})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  Future<IPath> createTask() {
    return FirestoreCollection.listen(
      "$target?filteredBy=$userId",
      query: FirestoreQuery.equalTo("user", userId)
          .orderByDesc("time")
          .limitAt(this.limit),
    );
  }

  @override
  Iterable<IDataDocument> build() {
    return PathMap.get<IDataCollection>("$target?filteredBy=$userId");
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target?filteredBy=$userId",
      label: label?.localize(),
    );
  }
}
