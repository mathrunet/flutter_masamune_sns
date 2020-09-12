part of masamune.sns;

class CheckEntryDocument extends DocumentModel {
  final String entryId;
  final String userId;
  CheckEntryDocument({String userId, String entryId})
      : this.entryId = entryId?.applyTags(),
        this.userId = userId?.applyTags(),
        super();
  @override
  FutureOr<IDataDocument> build(ModelContext context) {
    return FirestoreDocument.listen("user/$userId/entry/$entryId");
  }

  bool isEntried(BuildContext context) {
    if (context == null || isEmpty(entryId)) return false;
    return context.watch<String>("${this.context.path}/uid") == entryId;
  }
}
