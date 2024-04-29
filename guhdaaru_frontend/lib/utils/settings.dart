import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum DefinedPlatforms {
  macOs,
  windows,
  linux,
  android,
  ios,
  web,
  fuchsia
}

DefinedPlatforms definePlatform() {
  if(kIsWeb) {
    return DefinedPlatforms.web;
  } else if (Platform.isAndroid) {
    return DefinedPlatforms.android;
  } else if (Platform.isLinux) {
    return DefinedPlatforms.linux;
  } else if (Platform.isFuchsia) {
    return DefinedPlatforms.fuchsia;
  } else if (Platform.isMacOS) {
    return DefinedPlatforms.macOs;
  } else if (Platform.isIOS) {
    return DefinedPlatforms.ios;
  } else if (Platform.isWindows) {
    return DefinedPlatforms.windows;
  } else {
    throw Exception("Unsupported platform");
  }
}

class QueueLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if(!kIsWeb && Platform.isAndroid) {
      return false;
    } else {
      return true;
    }
  }
}

var platform = definePlatform();
Logger logger = Logger(
    printer: PrettyPrinter(printTime: true),
    level: Level.all,
    filter: QueueLogFilter()
);