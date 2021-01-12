import 'dart:ui';

import 'package:flutter/material.dart';

import 'event_stream.dart';

class HeaderView extends StatefulWidget {
  final List<String> titleList;

  final double headerHeight;
  final double headerWidth;

  final TextStyle normalStyle;
  final TextStyle selectStyle;
  final EdgeInsets padding;

  final Color lineColor;
  final double lineHeight;
  final double lineWidth;

  HeaderView(this.titleList,
      {this.headerHeight = 50,
      this.normalStyle = const TextStyle(color: Colors.black, fontSize: 15),
      this.selectStyle = const TextStyle(color: Colors.black, fontSize: 15),
      this.padding = const EdgeInsets.only(left: 12, right: 12),
      this.lineColor = Colors.red,
      this.lineHeight = 3,
      this.lineWidth = 15,
      this.headerWidth});

  @override
  _HeaderViewState createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> with TickerProviderStateMixin {
  ScrollController _scrollController;
  List<GlobalKey<_HeaderViewState>> _keyList;
  List<Widget> _widgetList;

  AnimationController _animationController;
  Animation<double> _animation;

  /// 原始滚动位置 ScrollController 相关
  double _originOffSet;

  /// 开始滚动位置
  double _startOffSet = 0.0;

  /// 滚动位置
  double _offSetX = 0.0;

  int _selectIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _keyList = List<GlobalKey<_HeaderViewState>>();
    _widgetList = List<Widget>();

    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 0.0).animate(_animationController);

    /// 设置默认第一个偏移量 是选中 第几个
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      EventStream().post(0);
    });

    /// 定制要现实的widget
    for (int index = 0; index < widget.titleList.length; index++) {
      GlobalKey<_HeaderViewState> _key = GlobalKey<_HeaderViewState>();
      Widget contentWidget = this.contentWidget(index, _key);
      _keyList.add(_key);
      _widgetList.add(contentWidget);
    }

    /// 监听ScrollController滚动
    _scrollController.addListener(() {
      _offSetX = _originOffSet - _scrollController.offset;
      _startAnimation(_startOffSet, _offSetX);
      _startOffSet = _offSetX;
    });

    EventStream().add((event) {
      RenderBox renderBox = _keyList[event].currentContext.findRenderObject();
      double offsetX = renderBox.localToGlobal(Offset.zero).dx;
      Size size = renderBox.size;

      double leftMargin = widget.headerWidth == null
          ? 0
          : (MediaQuery.of(context).size.width -
                  widget.headerWidth * widget.titleList.length) *
              0.5;

      /// 要偏移的位置
      _offSetX = offsetX + (size.width - widget.lineWidth) * 0.5 - leftMargin;

      /// 记录_scrollController 滚动的位置
      _originOffSet = _scrollController.offset + _offSetX;

      /// 执行动画
      _startAnimation(_startOffSet, _offSetX);

      /// 记录偏移后的位置
      _startOffSet = _offSetX;
    });
    super.initState();
  }

  Widget contentWidget(int index, GlobalKey<_HeaderViewState> _key) {
    return InkWell(
      child: Container(
        width: widget.headerWidth,
        key: _key,
        height: widget.headerHeight,
        padding: widget.padding,
        child: Center(
          child: Text(
            widget.titleList[index],
            style:
                index == _selectIndex ? widget.selectStyle : widget.normalStyle,
          ),
        ),
      ),
      onTap: () {
        EventStream().post(index);
      },
    );
  }

  void _startAnimation(double startOffSetX, double endOffSetX) {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: startOffSetX, end: endOffSetX)
        .animate(_animationController);
    _animationController.fling();

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            height: widget.headerHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              children: _widgetList,
            ),
          ),
          Positioned(
            top: widget.headerHeight - widget.lineHeight,
            child: Transform(
              transform: Matrix4.identity()..translate(_animation.value, 0.0),
              child: Container(
                width: widget.lineWidth,
                height: widget.lineHeight,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.lineHeight * 0.5),
                    color: widget.lineColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
