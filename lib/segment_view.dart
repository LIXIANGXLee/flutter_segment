import 'package:flutter/material.dart';

import 'content_view.dart';
import 'header_view.dart';

class SegmentView extends StatefulWidget {
  @override
  _SegmentViewState createState() => _SegmentViewState();

  final List<String> titleList;
  final List<Widget> widgetList;

  final EdgeInsets margin;

  final double headerHeight;
  final double headerWidth;

  final TextStyle normalStyle;
  final TextStyle selectStyle;
  final EdgeInsets padding;

  final Color lineColor;
  final double lineHeight;
  final double lineWidth;

  SegmentView(
      {@required this.titleList,
      @required this.widgetList,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.only(left: 12, right: 12),
      this.headerHeight = 50,
      this.headerWidth,
      this.normalStyle,
      this.selectStyle,
      this.lineColor,
      this.lineWidth,
      this.lineHeight});
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
              ContentView(widget.widgetList),
            ],
          ),
          HeaderView(
            widget.titleList,
            headerWidth: (MediaQuery.of(context).size.width -
                    widget.margin.left -
                    widget.margin.right) /
                widget.titleList.length,
            headerHeight: widget.headerHeight,
          )
        ],
      ),
    );
  }
}
