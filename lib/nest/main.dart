library lidea.nest;

// NOTE: Mock
import 'dart:math';
// NOTE: UtilDocument
import 'dart:async';
import 'dart:typed_data';
// import 'dart:math';
import 'dart:convert' show json, utf8;
import 'dart:io'
    show
        Directory,
        File,
        FileSystemEntity,
        HttpClientResponse,
        HttpClientRequest,
        HttpClient,
        SocketException,
        Platform;

import 'package:flutter/foundation.dart' show kIsWeb, consolidateHttpClientResponseBytes;
import 'package:flutter/services.dart' show ByteData, PlatformException, rootBundle;

import 'package:path/path.dart' show join, basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
// GZipDecoder, BZip2Decoder, XZDecoder, ZLibDecoder
import 'package:archive/archive.dart'
    show Archive, ZipDecoder, TarDecoder, GZipDecoder, BZip2Decoder;

// NOTE: ClusterController
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// NOTE: ClusterDocket
import 'package:lidea/hive.dart';
import 'package:lidea/extension.dart';
import 'package:lidea/type/main.dart';
import 'package:lidea/intl.dart';
// import 'package:lidea/firebase/core.dart';
// import 'package:lidea/firebase/firestore.dart';

part 'data.dart';
part 'preference.dart';
part 'poll.dart';

part 'theme/main.dart';

part 'util/main.dart';
part 'util/ask.dart';
part 'util/archive.dart';
part 'util/gist.dart';
