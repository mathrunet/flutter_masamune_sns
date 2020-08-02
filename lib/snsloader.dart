part of masamune.sns;

/// Loader for SNS.
class SNSLoader {
  /// Gets the user collection that the user is following.
  static IDataCollection readFollow(BuildContext context, {String userId}) {
    return context.watch<IDataCollection>("joined/user/$userId/follow");
  }

  /// Button widget to load the next data of the following user.
  static LoadNext loadNextFollow({String userId, String label}) {
    return LoadNext(
      path: "user/$userId/follow",
      label: label,
    );
  }

  /// Loader to get the users who are following.
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
  static IDataCollection readFollower(BuildContext context, {String userId}) {
    return context.watch<IDataCollection>("joined/user/$userId/follower");
  }

  /// Button widget to load the next data of the follower user.
  static LoadNext loadNextFollower({String userId, String label}) {
    return LoadNext(
      path: "user/$userId/follower",
      label: label,
    );
  }

  /// Loader for getting followers.
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
  static IDataCollection readUserTimeline(BuildContext context,
      {String userId}) {
    return context.watch("timeline?user=$userId");
  }

  /// Widget for loading the next of the user timeline collection.
  static LoadNext loadNextUserTimeline({String userId, String label}) {
    return LoadNext(
      path: "timeline?user=$userId",
      label: label,
    );
  }

  /// Loader for retrieving user timeline collection.
  static Future<IDataCollection> initUserTimeline(
      {String userId, int length = 100}) {
    return FirestoreCollection.listen("timeline?user=$userId",
        query: FirestoreQuery.equalTo("user", userId)
            .orderByDesc("postTime")
            .limitAt(length));
  }

  /// Collection for displaying the home timeline collection (self + follow).
  static IDataCollection readHomeTimeline(BuildContext context) {
    return context.watch("joined/timeline");
  }

  /// Widget to read additional home timeline.
  static LoadNext loadNextHomeTimeline({String key = "home", String label}) {
    return LoadNext(
      path: "timeline?$key",
      label: label,
    );
  }

  /// Loader for home timeline.
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
