part of masamune.sns;

/// Utility for SNS.
class SNSUtility {
  static Future _increment(String path, int value) async {
    String parent = Paths.parent(path);
    String key = Paths.last(path);
    IDataDocument doc = PathMap.get(parent);
    if (doc == null) {
      if (value < 0) return;
      DataField(path, value);
      doc = await FirestoreDocument.listen(parent);
      doc[key] = (doc.getInt(key, 0) + value).limitLow(0);
    } else {
      doc[key] = (doc.getInt(key, 0) + value).limitLow(0);
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

    return Future.wait([
      followDoc.save(),
      followerDoc.save(),
      _increment("user/$followId/followerCount", 1),
      _increment("user/$userId/followCount", 1)
    ]);
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
    return Future.wait([
      FirestoreDocument.deleteAt("user/$followId/follower/$userId"),
      FirestoreDocument.deleteAt("user/$userId/follow/$followId"),
      _increment("user/$followId/followerCount", -1),
      _increment("user/$userId/followCount", -1)
    ]);
  }

  /// Set up the initial loading settings for executing [isFollow].
  ///
  /// [userId]: ID of the person to entry.
  /// [followId]: ID of the person being followed.
  static Future<IDataDocument> initCheckFollow(String userId, String followId) {
    if (isEmpty(followId) || isEmpty(userId))
      return Future.delayed(Duration.zero);
    followId = followId.applyTags();
    userId = userId.applyTags();
    return FirestoreDocument.listen("user/$userId/follow/$followId");
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
    return context.watch<String>("user/$userId/follow/$followId/uid") ==
        followId;
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

    return Future.wait([
      user.save(),
      like.save(),
      _increment("$target/$likeId/likedCount", 1)
    ]);
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
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/like/$likeId"),
      FirestoreDocument.deleteAt("$target/$likeId/liked/$userId"),
      _increment("$target/$likeId/likedCount", -1)
    ]);
  }

  /// Set up the initial loading settings for executing [isLike].
  ///
  /// [userId]: ID of the person to entry.
  /// [likeId]: ID of the person being like.
  static Future<IDataDocument> initCheckLike(String userId, String likeId) {
    if (isEmpty(likeId) || isEmpty(userId))
      return Future.delayed(Duration.zero);
    likeId = likeId.applyTags();
    userId = userId.applyTags();
    return FirestoreDocument.listen("user/$userId/like/$likeId");
  }

  /// Check if [userId] is liked [likeId].
  ///
  /// True if you are liked.
  ///
  /// It will be rebuilt if the data state changes.
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [context]: BuildContext.
  /// [userId]: ID of the person to like.
  /// [likeId]: ID of the person being like.
  static bool isLike(BuildContext context, String userId, String likeId) {
    if (context == null || isEmpty(likeId) || isEmpty(userId)) return false;
    likeId = likeId.applyTags();
    userId = userId.applyTags();
    return context.watch<String>("user/$userId/like/$likeId/uid") == likeId;
  }

  /// Entry the data ([entryId]) is placed in [target] by [userId].
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [userId]: The user to entry.
  /// [entryId]: ID to be entry.
  /// [target]: Data path where [entryId] is stored.
  static Future entry(String userId, String entryId,
      [String target = "event"]) async {
    if (isEmpty(entryId) || isEmpty(userId) || isEmpty(target)) return;
    entryId = entryId.applyTags();
    userId = userId.applyTags();
    target = target.applyTags();
    final user = FirestoreDocument.create("user/$userId/entry/$entryId");
    FirestoreDocument entry =
        FirestoreDocument.create("$target/$entryId/entry/$userId");

    return Future.wait([
      user.save(),
      entry.save(),
      _increment("$target/$entryId/entryCount", 1)
    ]);
  }

  /// Exit the data ([exitId]) is placed in [target] by [userId].
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [userId]: The user to exit.
  /// [exitId]: ID to be exit.
  /// [target]: Data path where [exitId] is stored.
  static Future exit(String userId, String exitId,
      [String target = "event"]) async {
    if (isEmpty(exitId) || isEmpty(userId) || isEmpty(target)) return;
    exitId = exitId.applyTags();
    userId = userId.applyTags();
    target = target.applyTags();
    return Future.wait([
      FirestoreDocument.deleteAt("user/$userId/entry/$exitId"),
      FirestoreDocument.deleteAt("$target/$exitId/entry/$userId"),
      _increment("$target/$exitId/entryCount", -1)
    ]);
  }

  /// Set up the initial loading settings for executing [isEntry].
  ///
  /// [userId]: ID of the person to entry.
  /// [entryId]: ID of the person being entry.
  static Future<IDataDocument> initCheckEntry(String userId, String entryId) {
    if (isEmpty(entryId) || isEmpty(userId))
      return Future.delayed(Duration.zero);
    entryId = entryId.applyTags();
    userId = userId.applyTags();
    return FirestoreDocument.listen("user/$userId/entry/$entryId");
  }

  /// Check if [userId] is entry to [entryId].
  ///
  /// True if you are entried.
  ///
  /// It will be rebuilt if the data state changes.
  ///
  /// Various IDs can use PathTag format.
  ///
  /// [context]: BuildContext.
  /// [userId]: ID of the person to entry.
  /// [entryId]: ID of the person being entry.
  static bool isEntry(BuildContext context, String userId, String entryId) {
    if (context == null || isEmpty(entryId) || isEmpty(userId)) return false;
    entryId = entryId.applyTags();
    userId = userId.applyTags();
    return context.watch<String>("user/$userId/entry/$entryId/uid") == entryId;
  }

  /// Gets the user collection that the user is following.
  ///
  /// [context]: Build Context.
  /// [userId]: ID of the user to read.
  static IDataCollection readFollow(BuildContext context,
      {@required String userId}) {
    userId = userId?.applyTags();
    return context
        .watch<IDataCollection>("joined/user/$userId/follow?user=$userId");
  }

  /// Button widget to load the next data of the following user.
  ///
  /// [userId]: ID of the user to read.
  /// [label]: Button label.
  static LoadNext loadNextFollow(
      {@required String userId, @required String label}) {
    userId = userId?.applyTags();
    return LoadNext(
      path: "user/$userId/follow?user=$userId",
      label: label,
    );
  }

  /// Loader to get the users who are following.
  ///
  /// [userId]: ID of the user to read.
  /// [length]: Number of cases to read.
  static Future<IDataCollection> initFollow(
      {@required String userId, int length = 100}) {
    userId = userId?.applyTags();
    return FirestoreCollection.listen("user/$userId/follow?user=$userId",
            query: FirestoreQuery.orderByDesc("time").limitAt(length))
        .joinAt(
            path: "joined/user/$userId/follow?user=$userId",
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
  static IDataCollection readFollower(BuildContext context,
      {@required String userId}) {
    userId = userId?.applyTags();
    return context
        .watch<IDataCollection>("joined/user/$userId/follower?user=$userId");
  }

  /// Button widget to load the next data of the follower user.
  ///
  /// [userId]: ID of the user to read.
  /// [label]: Button label.
  static LoadNext loadNextFollower(
      {@required String userId, @required String label}) {
    return LoadNext(
      path: "user/$userId/follower?user=$userId",
      label: label,
    );
  }

  /// Loader for getting followers.
  ///
  /// [userId]: ID of the user to read.
  /// [length]: Number of cases to read.
  static Future<IDataCollection> initFollower(
      {@required String userId, int length = 100}) {
    userId = userId?.applyTags();
    return FirestoreCollection.listen("user/$userId/follower?user=$userId",
            query: FirestoreQuery.orderByDesc("time").limitAt(length))
        .joinAt(
            path: "joined/user/$userId/follower?user=$userId",
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
            return FirestoreCollection.listen(
                "user/[UID]/follow?folllowerJoinedby=$userId",
                query: col.length <= 0
                    ? FirestoreQuery.empty()
                    : FirestoreQuery.inArray("uid", col.map((e) => e.uid)));
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
      {@required String userId}) {
    userId = userId?.applyTags();
    return context.watch("timeline?user=$userId");
  }

  /// Widget for loading the next of the user timeline collection.
  ///
  /// [userId]: ID of the user to read.
  /// [label]: Button label.
  static LoadNext loadNextUserTimeline(
      {@required String userId, @required String label}) {
    userId = userId?.applyTags();
    return LoadNext(
      path: "timeline?user=$userId",
      label: label,
    );
  }

  /// Loader for retrieving user timeline collection.
  ///
  /// [userId]: ID of the user to read.
  /// [length]: Number of cases to read.
  static Future initUserTimeline({@required String userId, int length = 100}) {
    userId = userId?.applyTags();
    return Future.wait([
      FirestoreCollection.listen("user/[UID]/follow?checkAt=$userId",
          query: FirestoreQuery.equalTo("uid", userId)),
      FirestoreDocument.listen("user/[UID]/like/$userId"),
      FirestoreDocument.listen("user/$userId"),
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
  static LoadNext loadNextHomeTimeline(
      {String key = "home", @required String label}) {
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
      {@required String userId,
      String key = "home",
      int length = 100,
      String userPrefix = "user_"}) async {
    userId = userId?.applyTags();
    final follow =
        await FirestoreCollection.listen("user/$userId/follow?all").joinAt(
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
          return FirestoreCollection.listen("user/$userId/like?joinedBy=$key",
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

  /// Gets the callback used for onItemFound of SearchBar.
  static Widget Function(BuildContext, IDataDocument<IDataField>, int)
      onSearchItemFound(
          {ImageProvider image,
          @required Function onTap,
          String nameKey = "name",
          String photoKey = "photo",
          String uidKey = "uid"}) {
    return (context, data, index) {
      if (SNSUtility.isMyID(data.getString(uidKey))) return Container();
      return ListTile(
          onTap: onTap,
          leading: image != null
              ? Container(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    backgroundColor: context.theme.disabledColor,
                    backgroundImage:
                        NetworkOrAsset.image(data.getString(photoKey)),
                  ))
              : null,
          title: Text(data.getString(nameKey)));
    };
  }
}
