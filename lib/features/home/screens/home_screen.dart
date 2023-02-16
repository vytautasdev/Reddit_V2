import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_v2/core/constants/constants.dart';
import 'package:reddit_v2/features/auth/controller/auth_controller.dart';
import 'package:reddit_v2/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_v2/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_v2/features/home/drawers/profile_drawer.dart';
import 'package:reddit_v2/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _pageIndex = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post/');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref)),
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => navigateToAddPost(context),
              icon: const Icon(Icons.add)),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
            );
          })
        ],
      ),
      body: Constants.tabWidgets[_pageIndex],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.backgroundColor,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
              ],
              onTap: onPageChange,
              currentIndex: _pageIndex,
            ),
    );
  }
}
