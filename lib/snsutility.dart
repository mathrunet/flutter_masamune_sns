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
}
