import 'package:logger/logger.dart';

import '../environment/app_environment.dart';

Logger createAppLogger(AppEnvironment environment) => Logger(
  level: environment.enableLogs ? Level.trace : Level.off,
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5),
);

late Logger appLogger;

void setAppLogger(Logger logger) {
  appLogger = logger;
}
