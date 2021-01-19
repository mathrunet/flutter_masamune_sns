part of masamune.sns;

class ReportCollectionModel extends CollectionModel {
  final int limit;
  final String reportId;
  final String target;
  ReportCollectionModel(
      {@required String reportId, this.limit = 100, String target = "timeline"})
      : this.reportId = reportId?.applyTags(),
        this.target = target?.applyTags(),
        super("joined/$target/$reportId/report");

  @override
  Future<IDataCollection> build(ModelContext context) {
    return FirestoreCollection.listen(
      "$target/$reportId/report",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    ).joinAt(
      path: this.path,
      key: "uid",
      builder: (col) {
        return FirestoreCollection.listen("user?reportJoinedby=$reportId",
            query: col.length <= 0
                ? FirestoreQuery.empty()
                : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
      },
    );
  }

  Future report(String userId) async {
    if (isEmpty(userId) || isEmpty(reportId) || isEmpty(target)) return;
    userId = userId.applyTags();
    final user = FirestoreDocument.create("$target/$reportId/report/$userId");
    return Future.wait([
      user.save(),
      FirestoreUtility.increment("$target/$reportId/reportCount", 1)
    ]);
  }

  Future unreport(String userId) async {
    if (isEmpty(userId) || isEmpty(reportId) || isEmpty(target)) return;
    userId = userId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("$target/$reportId/report/$userId"),
      FirestoreUtility.increment("$target/$reportId/reportCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "$target/$reportId/report",
      label: label?.localize(),
    );
  }
}
