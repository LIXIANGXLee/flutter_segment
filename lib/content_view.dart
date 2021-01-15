import 'package:flutter/material.dart';

import 'event_controller.dart';

class ContentView extends StatefulWidget {
  final List<Widget> contentList;
  final int animationDuration;
  final EventController controller;

  ContentView(this.contentList,
      {this.animationDuration = 150, @required this.controller});

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    widget.controller.add((event) {
      if (widget.controller.isTap) {
        _pageController.animateToPage(event,
            duration: Duration(milliseconds: widget.animationDuration),
            curve: Curves.linear)
          ..then((value) {
            widget.controller.isTap = false;
          });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.controller.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        children: widget.contentList,
        scrollDirection: Axis.horizontal,
        reverse: false,
        physics: ClampingScrollPhysics(),
        pageSnapping: true,
        onPageChanged: (index) {
          if (!widget.controller.isTap) {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: widget.animationDuration),
                curve: Curves.linear)
              ..then((value) {
                widget.controller.isTap = false;
                widget.controller.post(index);
              });
          }
        },
      ),
    );
  }
}
