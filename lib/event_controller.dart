import 'dart:async';

typedef EventControllerCallBack = void Function(int event);

class EventController {

  /// 内部构造方法
  EventController() : _streamController = StreamController.broadcast();
  
  StreamController<int> _streamController;

  /// 记录监听的发送者
  bool isTap = true;

  StreamController<int> get streamController => _streamController;

  void add(EventControllerCallBack callBack) {
    streamController.stream.listen(callBack);
  }

  void post(int event) {
    streamController.add(event);
  }

  void destroy() {
    streamController.close();
  }
}
