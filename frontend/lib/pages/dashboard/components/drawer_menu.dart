import 'package:flutter/material.dart';
import 'package:frontend/pages/logout.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/layout_constants.dart';
import 'drawer_list_tile.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(

        children: [
          Image.asset(width: 170, height: 155,
            "assets/images/logo_bloc360_transparent.png",
          ),
          DrawerListTile(
              title: 'Dashboard',
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {
                print('You Click Dash Board');
              }),
          DrawerListTile(
              title: 'Cheltuieli',
              svgSrc: 'assets/icons/BlogPost.svg',
              tap: () {}),
          DrawerListTile(
              title: 'Rapoarte', svgSrc: 'assets/icons/Message.svg', tap: () {}),
          DrawerListTile(
              title: 'Membri',
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Setari',
              svgSrc: 'assets/icons/Setting.svg',
              tap: () {}),
          DrawerListTile(
              tap: () {
                Logout().logout(() => context.go('/login'));
              },
              title: 'Logout',
              svgSrc: 'assets/icons/Logout.svg'),
        ],
      ),
    );
  }
}
