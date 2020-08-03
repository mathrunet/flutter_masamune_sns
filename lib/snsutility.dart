part of masamune.sns;

/// Utility for SNS.
class SNSUtility {
  static void _increment(String path, int value) {
    IDataField field = PathMap.get<IDataField>(path);
    if (field == null) {
      if (value < 0) return;
      DataField(path, value);
    } else {
      field.data = ((field.data as int) + value.toInt()).limitLow(0);
    }
  }

  /// True if the ID is your own.
  ///
  /// [userId] can also be used in PathTag format.
  ///
  /// [userId]: ID you want to check.
  static bool isMyID(String userId) {
    if (isEmpty(userId)) return false;
    userId = userId.applyTags();
    return userId == FirestoreAuth.getUID();
  }

  /// [userId] follows [followId].
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [userId]: ID of the person to follow.
  /// [followId]: ID of the person being followed.
  static Future follow(String userId, String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    userId = userId.applyTags();
    final followDoc = FirestoreDocument.create("user/$userId/follow/$followId");
    FirestoreDocument followerDoc =
        FirestoreDocument.create("user/$followId/follower/$userId");
    _increment("user/$followId/followerCount", 1);
    _increment("user/$userId/followCount", 1);
    return Future.wait([followDoc.save(), followerDoc.save()]);
  }

  /// Unfollow [userId] to [followId].
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [userId]: ID of the person to follow.
  /// [followId]: ID of the person being followed.
  static Future unfollow(String userId, String followId) async {
    if (isEmpty(followId) || isEmpty(userId)) return;
    followId = followId.applyTags();
    userId = userId.applyTags();
    _increment("user/$followId/followerCount", -1);
    _increment("user/$userId/followCount", -1);
    return Future.wait([
      FirestoreDocument.deleteAt("user/$followId/follower/$userId"),
      FirestoreDocument.deleteAt("user/$userId/follow/$followId")
    ]);
  }

  /// Check if [userId] is following [followId].
  ///
  /// True if you are following.
  ///
  /// It will be rebuilt if the data state changes.
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [context]: BuildContext.
  /// [userId]: ID of the person to follow.
  /// [followId]: ID of the person being followed.
  static bool isFolllow(BuildContext context, String userId, String followId) {
    if (context == null || isEmpty(followId) || isEmpty(userId)) return false;
    followId = followId.applyTags();
    userId = userId.applyTags();
    return context
            .watch<IDataCollection>("user/$userId/follow")
            ?.any((element) => element.uid == followId) ??
        false;
  }

  /// Like the data ([likeId]) is placed in [target] by [userId].
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [userId]: The user to like.
  /// [likeId]: ID to be like.
  /// [target]: Data path where [likeId] is stored.
  static Future like(String userId, String likeId,
      [String target = "user"]) async {
    if (isEmpty(likeId) || isEmpty(userId) || isEmpty(target)) return;
    likeId = likeId.applyTags();
    userId = userId.applyTags();
    target = target.applyTags();
    final user = FirestoreDocument.create("user/$userId/like/$likeId");
    FirestoreDocument like =
        FirestoreDocument.create("$target/$likeId/liked/$userId");
    _increment("$target/$likeId/likedCount", 1);
    return Future.wait([user.save(), like.save()]);
  }

  /// Unlike the data ([likeId]) is placed in [target] by [userId].
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [userId]: The user to like.
  /// [likeId]: ID to be like.
  /// [target]: Data path where [likeId] is stored.
  static Future unlike(String userId, String likeId,
      [String target = "user"]) async {
    if (isEmpty(likeId) || isEmpty(userId) || isEmpty(target)) return;
    likeId = likeId.applyTags();
    userId = userId.applyTags();
    target = target.applyTags();
    _increment("$target/$likeId/likedCount", -1);
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/like/$likeId"),
      FirestoreDocument.deleteAt("$target/$likeId/liked/$userId")
    ]);
  }

  /// Gets the user collection that the user is following.
  ///
  /// [context]: Build Context.
  /// [userId]: ID of the user to read.
  static IDataCollection readFollow(BuildContext context, {String userId}) {
    return context.watch<IDataCollection>("joined/user/$userId/follow");
  }

  /// Button widget to load the next data of the following user.
  ///
  /// [userId]: ID of the user to read.
  /// [label]: Button label.
  static LoadNext loadNextFollow({String userId, String label}) {
    return LoadNext(
      path: "user/$userId/follow",
      label: label,
    );
  }

  /// Loader to get the users who are following.
  ///
  /// [userId]: ID of the user to read.
  /// [length]: Number of cases to read.
  static Future<IDataCollection> initFollow({String userId, int length = 100}) {
    return FirestoreCollection.listen("user/$userId/follow",
            query: FirestoreQuery().orderByDesc("time").limitAt(length))
        .joinAt(
            key: "uid",
            builder: (col) {
              return FirestoreCollection.listen("user?followJoinedby=$userId",
                  query: col.length <= 0
                      ? FirestoreQuery.empty()
                      : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
            });
  }

  /// User collection of followers.
  ///
  /// [context]: Build Context.
  /// [userId]: ID of the user to read.
  static IDataCollection readFollower(BuildContext context, {String userId}) {
    return context.watch<IDataCollection>("joined/user/$userId/follower");
  }

  /// Button widget to load the next data of the follower user.
  ///
  /// [userId]: ID of the user to read.
  /// [label]: Button label.
  static LoadNext loadNextFollower({String userId, String label}) {
    return LoadNext(
      path: "user/$userId/follower",
      label: label,
    );
  }

  /// Loader for getting followers.
  ///
  /// [userId]: ID of the user to read.
  /// [length]: Number of cases to read.
  static Future<IDataCollection> initFollower(
      {String userId, int length = 100}) {
    return FirestoreCollection.listen("user/$userId/follower",
            query: FirestoreQuery().orderByDesc("time").limitAt(length))
        .joinAt(
            key: "uid",
            builder: (col) {
              return FirestoreCollection.listen("user?followerJoinedby=$userId",
                  query: col.length <= 0
                      ? FirestoreQuery.empty()
                      : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
            })
        .joinAt(
          key: "uid",
          builder: (col) {
            return FirestoreCollection.listen("user/[UID]/follow");
          },
          onFound: (key, value, document, collection) {
            value["follow"] = true;
          },
          onNotFound: (key, value, collection) {
            value["follow"] = false;
          },
        );
  }

  /// Timeline collection to use for each user's timeline (profile, etc.).
  ///
  /// [context]: Build Context.
  /// [userId]: ID of the user to read.
  static IDataCollection readUserTimeline(BuildContext context,
      {String userId}) {
    return context.watch("timeline?user=$userId");
  }

  /// Widget for loading the next of the user timeline collection.
  ///
  /// [userId]: ID of the user to read.
  /// [label]: Button label.
  static LoadNext loadNextUserTimeline({String userId, String label}) {
    return LoadNext(
      path: "timeline?user=$userId",
      label: label,
    );
  }

  /// Loader for retrieving user timeline collection.
  ///
  /// [userId]: ID of the user to read.
  /// [length]: Number of cases to read.
  static Future initUserTimeline({String userId, int length = 100}) {
    return Future.wait([
      FirestoreCollection.listen("user/[UID]/follow"),
      FirestoreDocument.listen("user/[UID]/like/$userId"),
      FirestoreDocument.listen("user/$userId"),
      FirestoreCollection.listen("user/$userId/follow"),
      FirestoreCollection.listen("user/$userId/follower"),
      FirestoreCollection.listen("timeline?user=$userId",
          query: FirestoreQuery.equalTo("user", userId.applyTags())
              .orderByDesc("postTime")
              .limitAt(length))
    ]);
  }

  /// Collection for displaying the home timeline collection (self + follow).
  ///
  /// [context]: Build Context.
  static IDataCollection readHomeTimeline(BuildContext context) {
    return context.watch("joined/timeline");
  }

  /// Widget to read additional home timeline.
  ///
  /// [key]: Identification key.
  /// [label]: Button label.
  static LoadNext loadNextHomeTimeline({String key = "home", String label}) {
    return LoadNext(
      path: "timeline?$key",
      label: label,
    );
  }

  /// Loader for home timeline.
  ///
  /// [userId]: ID of the user to read.
  /// [key]: Identification key.
  /// [length]: Number of cases to read.
  /// [userPrefix]: User data prefix.
  static Future<IDataCollection> initHomeTimeline(
      {String userId,
      String key = "home",
      int length = 100,
      String userPrefix = "user_"}) async {
    final follow =
        await FirestoreCollection.listen("user/$userId/follow").joinAt(
            key: "uid",
            builder: (col) {
              return FirestoreCollection.listen("user?${key}Joinedby",
                  query: col.length <= 0
                      ? FirestoreQuery.empty()
                      : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
            });
    return FirestoreCollection.listen("timeline?$key",
        query: FirestoreQuery.inArray("user",
                follow.map((e) => e.uid).toList()..add(FirestoreAuth.getUID()))
            .orderByDesc("postTime")
            .limitAt(length))
      ..joinWhere(
          path: "joined/timeline",
          test: (newField, oldField) {
            return oldField.getString("uid") == newField.getString("user");
          },
          builder: (collection) async {
            return follow;
          },
          prefix: userPrefix)
      ..joinWhere(
        test: (original, additional) {
          return additional.uid == original.uid;
        },
        builder: (collection) {
          return FirestoreCollection.listen("user/$userId/like",
              query:
                  FirestoreQuery.inArray("uid", collection.map((e) => e.uid)));
        },
        onFound: (key, value, document, collection) {
          value["liked"] = true;
        },
        onNotFound: (key, value, collection) {
          value["liked"] = false;
        },
      )
      ..joinDocumentWhere(
        test: (newField, oldField) {
          return oldField.getString("uid") == newField.getString("user");
        },
        builder: (collection) async {
          return FirestoreDocument.listen("user/$userId");
        },
        prefix: userPrefix,
      );
  }
}
