import 'package:flutter/material.dart';
import 'package:capstone/widgets/widgets.dart';

class ScreenDashboard extends StatelessWidget {
  static const String routeName = '/dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarText('Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText('Dashboard'),
            HeaderText('Dashboard'),
            HeaderText('Dashboard'),
          ]),
      drawer: NavigatorButton(),
    );
  }
}
