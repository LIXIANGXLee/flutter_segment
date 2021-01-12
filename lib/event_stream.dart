import 'dart:async';

typedef EventStreamCallBack = void Function(int event);

class EventStream {
  static EventStream _instance;

  /// 内部构造方法
  EventStream._() : _streamController = StreamController.broadcast();

  /// 实现工厂构造方法 目的实现单列效果
  factory EventStream() => _instance ??= EventStream._();

  StreamController<int> _streamController;

  StreamController<int> get streamController => _streamController;

  void add(EventStreamCallBack callBack) {
    _streamController.stream.listen(callBack);
  }

  void post(int event) {
    _streamController.add(event);
  }

  void destroy() {
    _streamController.close();
  }
}
