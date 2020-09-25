part of masamune.sns;

class TimelineCollectionModel extends CollectionModel {
  final String userId;
  final String target;
  final int limit;
  TimelineCollectionModel(
      {String userId, String target = "timeline", this.limit = 100})
      : this.userId = userId?.applyTags(),
        this.target = target?.applyTags(),
        super();

  @override
  FutureOr<IDataCollection> build(ModelContext context) async {
    return FirestoreCollection.listen("$target?filteredBy=$userId",
        query: FirestoreQuery.equalTo("user", userId)
            .orderByDesc("time")
            .limitAt(this.limit));
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target?filteredBy=$userId",
      label: label?.localize(),
    );
  }
}
