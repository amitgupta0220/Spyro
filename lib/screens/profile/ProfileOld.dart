import 'package:flutter/material.dart';
import 'package:smackit/models/User.dart';
import 'package:smackit/services/authentication.dart';
import 'EditProfile.dart';
import 'package:smackit/Styles.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email, username, photoUrl, phone, location, about;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    UserData.getUser().then((userInfo) => setState(() {
          email = userInfo['email'];
          username = userInfo['uname'];
        }));
    UserData.getAdditionalInfo().then((userInfo) => setState(() {
          phone = userInfo['phone'];
          photoUrl = userInfo['photo_url'];
          location = userInfo['location'];
          about = userInfo['about'];
        }));
  }

  @override
  Widget build(BuildContext context) {
    // CloudMessaging.getToken().then((value) => print(value));
    const double radius = 50;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => EditProfile(
                          name: username,
                          phone: phone,
                          photoUrl: photoUrl,
                          location: location,
                          about: about)));
              getData();
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            SizedBox(height: 20),
            Center(
              child: Container(
                width: radius * 2 + 3,
                height: radius * 2 + 3,
                alignment: Alignment.center,
                child: CircleAvatar(
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl != null ? null : Icon(Icons.person),
                    radius: radius),
                decoration: BoxDecoration(
                    color: MyColors.secondary, shape: BoxShape.circle),
              ),
            ),
            Divider(
              color: MyColors.secondary,
              indent: 20,
              endIndent: 20,
              height: 30,
            ),
            DetailTile(icon: Icons.mail_outline, content: email ?? "Add Email"),
            DetailTile(icon: Icons.person, content: username ?? "Add Anme"),
            DetailTile(icon: Icons.phone, content: phone ?? 'Add Phone Number'),
            DetailTile(icon: Icons.info_outline, content: 'About'),
            Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Text(
                  about == null || about == '' ? 'Tell us about you !' : about,
                  softWrap: true,
                )),
            DetailTile(
                icon: Icons.location_on,
                content: location == null || location == ''
                    ? 'Add Location'
                    : location),
            OptionTile(
                title: 'My Reviews',
                leading: Icons.rate_review,
                trailing: Icons.arrow_forward_ios,
                route: '/reviews'),
            OptionTile(
                title: 'My Stores',
                leading: Icons.store,
                trailing: Icons.arrow_forward_ios,
                route: '/stores'),
            OptionTile(
                title: 'Logout',
                trailing: Icons.exit_to_app,
                action: () {
                  AuthService().signOut();
                  Navigator.pushReplacementNamed(context, '/auth');
                }),
          ]),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile(
      {@required this.title,
      @required this.trailing,
      this.leading,
      this.route,
      this.action})
      : assert(action != null || route != null);
  final String title, route;
  final IconData trailing, leading;
  final Function action;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          onTap: action ?? () => Navigator.pushNamed(context, route),
          title: Text(title,
              style: TextStyle(
                fontSize: 18,
                color: MyColors.secondary,
              )),
          leading: leading != null
              ? Icon(
                  leading,
                  color: MyColors.secondary,
                )
              : null,
          trailing: Icon(
            trailing,
            color: MyColors.secondary,
          ),
        ));
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({Key key, @required this.content, this.icon})
      : super(key: key);

  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
          leading: Icon(
            icon,
            color: MyColors.secondary,
          ),
          title: Text(
            content,
            style: TextStyle(fontFamily: 'Roboto'),
          )),
    );
  }
}
