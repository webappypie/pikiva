import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/core/design/app_copy.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigation, super.key});
  final StatefulNavigationShell navigation;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final labels = [copy.home, copy.creations, copy.sessions, copy.settings];
    const icons = [
      Icons.home_outlined,
      Icons.auto_awesome_mosaic_outlined,
      Icons.photo_library_outlined,
      Icons.tune_rounded,
    ];
    void select(int index) => navigation.goBranch(
      index,
      initialLocation: index == navigation.currentIndex,
    );
    final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 840 && scale <= 1.4) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigation.currentIndex,
                  onDestinationSelected: select,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (var i = 0; i < labels.length; i++)
                      NavigationRailDestination(
                        icon: Icon(icons[i]),
                        label: Text(labels[i]),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigation),
              ],
            ),
          );
        }
        return Scaffold(
          body: navigation,
          bottomNavigationBar: scale > 1.4
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Wrap(
                      children: [
                        for (var i = 0; i < labels.length; i++)
                          SizedBox(
                            width: (constraints.maxWidth - 16) / 2,
                            child: Semantics(
                              selected: navigation.currentIndex == i,
                              child: TextButton.icon(
                                onPressed: () => select(i),
                                icon: Icon(icons[i]),
                                label: Text(labels[i]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : NavigationBar(
                  selectedIndex: navigation.currentIndex,
                  onDestinationSelected: select,
                  destinations: [
                    for (var i = 0; i < labels.length; i++)
                      NavigationDestination(
                        icon: Icon(icons[i]),
                        label: labels[i],
                      ),
                  ],
                ),
        );
      },
    );
  }
}
