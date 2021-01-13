import 'package:flutter/material.dart';

import 'event_stream.dart';

class ContentView extends StatefulWidget {
  final List<Widget> contentList;
  final int animationDuration;

  ContentView(this.contentList, {this.animationDuration = 150});

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


    EventStream().add((event) {
      if (EventStream().isTap) {
        _pageController.animateToPage(
            event,
            duration: Duration(milliseconds: widget.animationDuration), curve: Curves.linear)
          ..then((value) {
            EventStream().isTap = false;
          });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    EventStream().destroy();
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
          if (!EventStream().isTap) {
            _pageController.animateToPage(
                index, duration: Duration(milliseconds: widget.animationDuration),
                curve: Curves.linear)
              ..then((value) {
                EventStream().isTap = false;
                EventStream().post(index);
              });
          }
        },
      ),
    );
  }
}
