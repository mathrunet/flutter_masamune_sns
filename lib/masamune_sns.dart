// Copyright 2020 mathru. All rights reserved.

/// Masamune SNS plugin framework library.
///
/// To use, import `package:masamune_sns/masamune_sns.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune.sns;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
import 'package:masamune_flutter/masamune_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masamune_list/masamune_list.dart';

export 'package:masamune_flutter/masamune_flutter.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'snsutility.dart';
part 'snseventcard.dart';
part 'snsuserlisttile.dart';
part 'snstimelinelisttile.dart';
part 'snsprofileheader.dart';
part 'snsprofilecontrol.dart';
part 'snschatmessagetext.dart';
part 'uipagechat.dart';

part 'model/followcollection.dart';
part 'model/followercollection.dart';
part 'model/checkfollowdocument.dart';
part 'model/likecollection.dart';
part 'model/likedcollection.dart';
part 'model/checklikedocument.dart';
part 'model/entrycollection.dart';
part 'model/entriedcollection.dart';
part 'model/checkentrydocument.dart';
part 'model/userfilteredcollection.dart';
part 'model/userfiltereddocument.dart';
part 'model/timelinecollection.dart';
part 'model/hometimelinecollection.dart';
