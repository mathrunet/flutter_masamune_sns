part of masamune.sns;

@immutable
class FollowCollecionModel extends CollectionModel {
  final int limit;
  final String userId;
  FollowCollecionModel({@required String userId, this.limit = 100})
      : this.userId = userId?.applyTags(),
        super();

  // @override
  // Future createTask() {
  //   return FirestoreCollection.listen(
  //     "user/$userId/follow",
  //     query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
  //   ).joinAt(
  //     key: "uid",
  //     builder: (col) {
  //       return FirestoreCollection.listen(
  //         "user?followJoinedby=$userId",
  //         query: col.length <= 0
  //             ? FirestoreQuery.empty()
  //             : FirestoreQuery.inArray(
  //                 "uid",
  //                 col.map((e) => e.uid),
  //               ),
  //       );
  //     },
  //   );
  // }

  @override
  IDynamicCollection build(ModelContext context) {
    final follow = FirestoreCollectionModel(
      "user/$userId/follow",
      query: FirestoreQuery.orderByDesc("time").limitAt(this.limit),
    );
    final user = FirestoreCollectionModel(
      "user?followJoinedby=$userId",
      query: follow.length <= 0
          ? FirestoreQuery.empty()
          : FirestoreQuery.inArray(
              "uid",
              follow.map((e) => e.uid),
            ),
    );
    return follow.mergeAt(key: "uid", source: user);
  }

  Future follow(String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    final followDoc = FirestoreDocument.create("user/$userId/follow/$followId");
    FirestoreDocument followerDoc =
        FirestoreDocument.create("user/$followId/follower/$userId");

    return Future.wait([
      followDoc.save(),
      followerDoc.save(),
      SNSUtility._increment("user/$followId/followerCount", 1),
      SNSUtility._increment("user/$userId/followCount", 1)
    ]);
  }

  Future unfollow(String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$followId/follower/$userId"),
      FirestoreDocument.deleteAt("user/$userId/follow/$followId"),
      SNSUtility._increment("user/$followId/followerCount", -1),
      SNSUtility._increment("user/$userId/followCount", -1)
    ]);
  }

  Widget loadNext(String label) {
    return LoadNext(
      path: "user/$userId/follow",
      label: label?.localize(),
    );
  }
}

extension MergeDataCollectionExtension<T extends IDynamicCollection> on T {
  TemporaryCollection _createCollection() {
    final tmp = TemporaryCollection();
    for (final doc in this) {
      final ndoc = TemporaryDocument();
      for (final key in doc.keys) ndoc[key] = doc[key];
      tmp.add(ndoc);
    }
    return tmp;
  }

  IDynamicCollection mergeAt(
      {@required IDynamicCollection source,
      String prefix,
      @required String key,
      void onFound(IDynamicDocument original, IDynamicDocument additional,
          IDynamicCollection collection),
      void onNotFound(
          IDynamicDocument original, IDynamicCollection collection)}) {
    final tmp = this is TemporaryCollection ? this : _createCollection();
    if (source == null) return tmp;
    tmp?.forEach((element) {
      final found = source.firstWhere(
          (value) => value.getString(key) == element.getString(key),
          orElse: () => null);
      if (found != null) {
        if (onFound != null) {
          onFound(element, found, source);
        } else {
          found?.keys?.forEach((key) => element["$prefix$key"] = found[key]);
        }
      } else if (onNotFound != null) {
        onNotFound(element, source);
      }
    });
    return tmp;
  }

  IDynamicCollection mergeWhere(
      {@required
          IDynamicCollection source,
      String prefix,
      @required
          bool test(IDynamicDocument original, IDynamicDocument additional),
      void onFound(IDynamicDocument original, IDynamicDocument additional,
          IDynamicCollection collection),
      void onNotFound(
          IDynamicDocument original, IDynamicCollection collection)}) {
    final tmp = this is TemporaryCollection ? this : _createCollection();
    if (source == null) return tmp;
    tmp?.forEach((element) {
      final found = source.firstWhere((value) => test(element, value),
          orElse: () => null);
      if (found != null) {
        if (onFound != null) {
          onFound(element, found, source);
        } else {
          found?.keys?.forEach((key) => element["$prefix$key"] = found[key]);
        }
      } else if (onNotFound != null) {
        onNotFound(element, source);
      }
    });
    return tmp;
  }

  IDynamicCollection mergeDocumentAt(
      {@required IDynamicDocument source,
      String prefix,
      @required String key,
      void onFound(IDynamicDocument original, IDynamicDocument additional),
      void onNotFound(IDynamicDocument original)}) {
    final tmp = this is TemporaryCollection ? this : _createCollection();
    if (source == null) return tmp;
    tmp?.forEach((element) {
      if (source.getString(key) == element.getString(key)) {
        if (onFound != null) {
          onFound(element, source);
        } else {
          source?.keys?.forEach((key) => element["$prefix$key"] = source[key]);
        }
      } else if (onNotFound != null) {
        onNotFound(element);
      }
    });
    return tmp;
  }

  IDynamicCollection mergeDocumentWhere(
      {@required
          IDynamicDocument source,
      String prefix,
      @required
          bool test(IDynamicDocument original, IDynamicDocument additional),
      void onFound(IDynamicDocument original, IDynamicDocument additional),
      void onNotFound(IDynamicDocument original)}) {
    final tmp = this is TemporaryCollection ? this : _createCollection();
    if (source == null) return tmp;
    tmp?.forEach((element) {
      if (test(element, source)) {
        if (onFound != null) {
          onFound(element, source);
        } else {
          source?.keys?.forEach((key) => element["$prefix$key"] = source[key]);
        }
      } else if (onNotFound != null) {
        onNotFound(element);
      }
    });
    return tmp;
  }
}
