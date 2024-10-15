import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/accountScreen.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/homeScreen.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/myCourseScreen.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/browseScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<IndexScreen> createState() => _IndexScreenState(pageIndex: pageIndex);
}

class _IndexScreenState extends State<IndexScreen> {
  final pages = [
    const HomeScreen(),
    const BrowseScreen(),
    const MyCourseScreen(),
    const AccountScreen()
  ];

  _IndexScreenState({required this.pageIndex});
  int pageIndex;
  void navigateMenu(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[pageIndex],
          Positioned(
            left: 11,
            right: 11,
            bottom: 15,
            child: Container(
              decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.15),
                      offset: Offset(0, 0),
                      blurRadius: 10,
                    )
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BottomNavigationBar(
                    onTap: navigateMenu,
                    currentIndex: pageIndex,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: primaryColor,
                    unselectedItemColor: bottomNavBarIconColor,
                    selectedLabelStyle: TextStyle(
                        color: bottomNavBarIconColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        TextStyle(color: bottomNavBarIconColor, fontSize: 12),
                    showUnselectedLabels: true,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: AppLocalizations.of(context)!.home),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.search_outlined),
                          label: AppLocalizations.of(context)!.browse),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.bookmark_outline),
                          label: AppLocalizations.of(context)!.myCourses),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.menu),
                          label: AppLocalizations.of(context)!.account)
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
