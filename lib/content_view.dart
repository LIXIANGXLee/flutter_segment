import 'package:flutter/material.dart';

import 'event_stream.dart';

class ContentView extends StatefulWidget {
  final List<Widget> contentList;

  ContentView(this.contentList);

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
      _pageController.animateToPage(event,
          duration: const Duration(milliseconds: 3), curve: Curves.ease);
    });
    super.initState();
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
          EventStream().post(index);
        },
      ),
    );
  }
}
