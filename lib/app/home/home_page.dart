import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/cupertino_home_scaffold.dart';
import 'package:flutter_time_tracker/app/home/jobs/job_page.dart';
import 'package:flutter_time_tracker/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => Container(),
    };
  }

  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }
}
