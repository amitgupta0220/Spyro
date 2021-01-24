import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:smackit/screens/chats/ChatsOld.dart';
import '../screens/profile/ProfileOld.dart';
import '../screens/Map.dart';
import '../screens/Home.dart';

class Screen {
  final String route;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
  final int index;
  const Screen(
      {@required this.index,
      @required this.route,
      @required this.title,
      @required this.icon,
      @required this.activeIcon,
      @required this.page});
  static final List<Screen> pages = [
    Screen(
        index: 0,
        route: '/home',
        icon: AntDesign.home,
        activeIcon: Icons.home,
        title: 'Home',
        page: HomePageOld()),
    Screen(
        index: 1,
        route: '/map',
        icon: SimpleLineIcons.location_pin,
        activeIcon: Icons.location_on,
        title: 'Map',
        page: MapScreen()),
    Screen(
        index: 2,
        route: '/add_store',
        icon: Icons.add_box,
        activeIcon: FontAwesome.home,
        title: 'Add Store',
        page: Container()),
    Screen(
        index: 3,
        route: '/chats',
        icon: Feather.message_square,
        activeIcon: Icons.chat,
        title: 'Chats',
        page: Chats()),
    Screen(
        index: 4,
        route: '/profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        title: 'Profile',
        page: ProfilePage())
  ];
}
