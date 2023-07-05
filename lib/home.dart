import 'package:custom_widgets/widgets/animated_progress.dart';
import 'package:flutter/material.dart';

import 'painted_widgets/circle_progress.dart';
import 'painted_widgets/custom_loading.dart';
import 'widgets/dots_list.dart';
import 'widgets/left_menu.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LeftMenu(
          menuContent: (closeMenu) => Container(color: Colors.brown),
          child: (openMenu) => _HomeContent(openMenu: openMenu),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final VoidCallback openMenu;

  const _HomeContent({Key? key, required this.openMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.segment, color: Colors.black),
                onPressed: openMenu,
              ),
            ),
            const SizedBox(height: 15),
            const CustomLoading(size: 100),
            const SizedBox(height: 15),
            const AnimatedProgress(maxProgress: 65),
            const SizedBox(height: 15),
            SizedBox(
              width: 200,
              child: DotsList(dots: dots),
            ),
          ],
        ),
      ),
    );
  }

  List<Dot> get dots => [
        Dot('Option1', Colors.red),
        Dot('Option2', Colors.green),
        Dot('Option3', Colors.blue),
      ];
}
