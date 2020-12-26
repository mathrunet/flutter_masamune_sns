// Copyright 2020 mathru. All rights reserved.

/// Masamune SNS plugin framework library.
///
/// To use, import `package:masamune_sns/masamune_sns.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune.sns;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
import 'package:masamune_flutter/masamune_flutter.dart';
import 'package:intl/intl.dart';

export 'package:masamune_flutter/masamune_flutter.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'snsutility.dart';
part 'snseventcard.dart';
part 'snsuserlisttile.dart';
part 'snstimelinelisttile.dart';
part 'snsprofileheader.dart';
part 'snsprofilecontrol.dart';
part 'snschatmessagetext.dart';
part 'snsgallerytile.dart';
part 'uipagechat.dart';
part 'uibottomchat.dart';
part 'snsbookmarkedlistcard.dart';
part 'snsprofilemenu.dart';

part 'model/followcollectionmodel.dart';
part 'model/postcommentcollectionmodel.dart';
part 'model/followercollectionmodel.dart';
part 'model/checkfollowdocumentmodel.dart';
part 'model/likecollectionmodel.dart';
part 'model/likedcollectionmodel.dart';
part 'model/checklikedocumentmodel.dart';
part 'model/entrycollectionmodel.dart';
part 'model/entriedcollectionmodel.dart';
part 'model/checkentrydocumentmodel.dart';
part 'model/userfilteredcollectionmodel.dart';
part 'model/userfiltereddocumentmodel.dart';
part 'model/timelinecollectionmodel.dart';
part 'model/timelinedocumentmodel.dart';
part 'model/hometimelinecollectionmodel.dart';
part 'model/bookmarkcollectionmodel.dart';
part 'model/checkreportdocumentmodel.dart';
part 'model/checkwatchdocumentmodel.dart';
part 'model/reportcollectionmodel.dart';
part 'model/checkblockeddocumentmodel.dart';
part 'model/blockcollectionmodel.dart';
