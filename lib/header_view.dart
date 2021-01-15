import 'dart:ui';

import 'package:flutter/material.dart';
import 'event_controller.dart';

typedef _RebuildFrameCallBack = void Function(double offsetX, double width);

class HeaderView extends StatefulWidget {

  HeaderView(this.titleList,
      { @required this.controller,
        this.isDivideEqually = true,
        this.animationDuration = 150,
        this.headerHeight = 50,
        this.headerWidth,
        this.headerBgColor = Colors.white,
        this.normalStyle = const TextStyle(color: Colors.black, fontSize: 15),
        this.selectStyle = const TextStyle(color: Colors.red, fontSize: 15),
        this.padding = const EdgeInsets.only(left: 12, right: 12),
        this.lineColor = Colors.red,
        this.lineHeight = 3,
        this.lineWidth = 15,
      });

  /// 头部数据源 <String> 类型的数据源
  final List<String> titleList;

  final EventController controller;

  /// 此属性如果是true 则是平分宽度，false则是内容宽度 并且可以滚动
  final bool isDivideEqually;

  /// 动画时长 单位 毫秒
  final int animationDuration;

  /// 头部widget的高度 和宽度 和 颜色
  final double headerHeight;
  final double headerWidth;
  final Color headerBgColor;

  ///头部widget的subwidget 字体样式
  final TextStyle normalStyle;
  final TextStyle selectStyle;

  ///头部widget的subwidget 内边距
  final EdgeInsets padding;

  /// 滑动的线颜色宽度 和高度
  final Color lineColor;
  final double lineHeight;
  final double lineWidth;

  @override
  _HeaderViewState createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> with TickerProviderStateMixin {
  ScrollController _scrollController;
  List<GlobalKey<_HeaderViewState>> _keyList;

  AnimationController _animationController;
  Animation<double> _animation;

  /// 原始滚动位置 ScrollController 相关
  double _originOffSet;

  /// 开始滚动位置
  double _startOffSet = 0.0;

  /// 滚动位置
  double _offSetX = 0.0;

  /// 选中的索引
  int _selectIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    widget.controller.destroy();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _keyList =
        widget.titleList.map((title) => GlobalKey<_HeaderViewState>()).toList();

    /// 设置默认第一个偏移量 是选中 第几个
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.post(0);
    });


    /// 监听ScrollController滚动
    _scrollController.addListener(() {
      _offSetX = _originOffSet - _scrollController.offset;

      /// 记录_scrollController 滚动的位置
      _originOffSet = _scrollController.offset + _offSetX;
      _startAnimation(_startOffSet, _offSetX);
      _startOffSet = _offSetX;
    });

    /// content滚动事件监听
    widget.controller.add((event) {
      _selectIndex = event;

      _rebuildFrame(event, (offsetX, width) {
        /// 左侧偏移量
        double leftMargin = widget.headerWidth == null
            ? 0 : (MediaQuery
            .of(context)
            .size
            .width - widget.headerWidth * widget.titleList.length) * 0.5;

        /// 要偏移的位置
        _offSetX = offsetX + (width - widget.lineWidth) * 0.5 - leftMargin;

        /// 记录_scrollController 滚动的位置
        _originOffSet = _scrollController.offset + _offSetX;
        _startAnimation(_startOffSet, _offSetX);
        _startOffSet = _offSetX;
      });
    });
    super.initState();
  }

  /// 根据索引获取宽度 和 偏移量图
  void _rebuildFrame(int index, _RebuildFrameCallBack callBack) {
    RenderBox renderBox = _keyList[index].currentContext.findRenderObject();
    double offsetX = renderBox
        .localToGlobal(Offset.zero)
        .dx;
    double width = renderBox.size.width;
    callBack(offsetX, width);
  }

  /// 单个内容widget
  Widget _contentWidget(int index, GlobalKey<_HeaderViewState> _key) {
    return InkWell(
      child: Container(
        width: widget.isDivideEqually ? widget.headerWidth : null,
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
        widget.controller.isTap = true;
        widget.controller.post(index);
      },
    );
  }

  /// 开始执行动画
  void _startAnimation(double startOffSetX, double endOffSetX) {
    _animationController =
        AnimationController(vsync: this,
            duration: Duration(milliseconds: widget.animationDuration));
    _animation =
    _animationController.drive(Tween(begin: startOffSetX, end: endOffSetX))
      ..addListener(() {
        setState(() {});
      });
    _animationController.fling();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.headerBgColor,
      child: Stack(
        children: [
          Container(
            height: widget.headerHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              children: List.generate(widget.titleList.length, (index) =>
                  _contentWidget(index, _keyList[index])).toList(),
            ),
          ),
          Positioned(
            top: widget.headerHeight - widget.lineHeight,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(_animation == null ? 0.0 : _animation.value, 0.0),
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
