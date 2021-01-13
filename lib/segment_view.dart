import 'package:flutter/material.dart';

import 'content_view.dart';
import 'header_view.dart';

class SegmentView extends StatefulWidget {
  @override
  _SegmentViewState createState() => _SegmentViewState();
  final bool isDivideEqually;

  final List<String> titleList;
  final List<Widget> widgetList;

  final EdgeInsets margin;

  final double headerHeight;
  final double headerWidth;
  final Color headerBgColor;

  final TextStyle normalStyle;
  final TextStyle selectStyle;
  final EdgeInsets padding;

  final Color lineColor;
  final double lineHeight;
  final double lineWidth;

  SegmentView({
    @required this.titleList,
    @required this.widgetList,
    this.isDivideEqually = true,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.only(left: 12, right: 12),
    this.headerHeight = 50,
    this.headerWidth,
    this.headerBgColor = Colors.white,
    this.normalStyle = const TextStyle(color: Colors.black, fontSize: 15),
    this.selectStyle = const TextStyle(color: Colors.red, fontSize: 15),
    this.lineColor = Colors.red,
    this.lineHeight = 3,
    this.lineWidth = 15,
  });
}

class _SegmentViewState extends State<SegmentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Stack(
        children: [
          Column(
            children: [
              ContentView(
                widget.widgetList,
              ),
            ],
          ),
          HeaderView(
            widget.titleList,
            isDivideEqually: widget.isDivideEqually,
            headerWidth: (MediaQuery.of(context).size.width -
                    widget.margin.left -
                    widget.margin.right) /
                widget.titleList.length,
            headerHeight: widget.headerHeight,
            headerBgColor: widget.headerBgColor,
            padding: widget.padding,
            normalStyle: widget.normalStyle,
            selectStyle: widget.selectStyle,
            lineColor: widget.lineColor,
            lineHeight: widget.lineHeight,
            lineWidth: widget.lineWidth,
          ),
        ],
      ),
    );
  }
}
