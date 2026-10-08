/// Logger mixin：为任何类提供日志能力
mixin Logger {
  /// 打印带类名的日志信息
  void log(String msg) => print('[$runtimeType] $msg');
}
