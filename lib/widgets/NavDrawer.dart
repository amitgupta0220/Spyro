import 'package:flutter/material.dart';
import '../Styles.dart';
import '../models/User.dart';
import '../services/authentication.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String username, email, photourl;
  @override
  void initState() {
    super.initState();
    UserData.getUser().then((currentUser) => setState(() {
          email = currentUser['email'];
          username = currentUser['uname'];
        }));
    UserData.getAdditionalInfo().then((currentUser) => setState(() {
          photourl = currentUser['photo_url'];
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
                child: UserAccountsDrawerHeader(
              // decoration: BoxDecoration(color: MyColors.primary),
              currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      photourl == null ? null : NetworkImage(photourl),
                  child: photourl != null ? null : Icon(Icons.person)),
              accountEmail: Text(email ?? 'Loading...'),
              accountName: username != null ? Text(username) : null,
              margin: const EdgeInsets.all(0),
            )),
            Expanded(
              child: Container(
                color: MyColors.primaryLight,
                child: ListView(
                  children: <Widget>[
                    DrawerItem(
                      icon: Icons.lock,
                      title: 'Account',
                      action: () {},
                    ),
                    DrawerItem(
                      icon: Icons.settings,
                      title: 'Setting',
                      action: () {},
                    ),
                    DrawerItem(
                      icon: Icons.add_comment,
                      title: 'Add Review',
                      action: () {},
                    ),
                    DrawerItem(
                      icon: Icons.info_outline,
                      title: 'FAQ',
                      action: () {},
                    ),
                    DrawerItem(
                      icon: Icons.chat,
                      title: 'Feedback',
                      action: () {},
                    ),
                    DrawerItem(
                      icon: Icons.star_border,
                      title: 'Rate Us',
                      action: () {},
                    ),
                    DrawerItem(
                      icon: Icons.exit_to_app,
                      title: 'Logout',
                      action: () async {
                        await AuthService().signOut();
                        await Future.delayed(Duration(milliseconds: 500));
                        Navigator.of(context).pushReplacementNamed('/auth');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function action;
  const DrawerItem(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          title: Text(title,
              style: TextStyle(
                  // color: MyColors.main_black,
                  fontSize: 20.0)),
          leading: Icon(
            icon,
            color: MyColors.secondary,
          ),
          onTap: action),
    );
  }
}
