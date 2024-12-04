import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/screens/contact_us.dart';

import '../screens/edit_profile_screen.dart';

class ProfileActionCard extends StatelessWidget {
  final VoidCallback onSignOut;

  const ProfileActionCard({Key? key, required this.onSignOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => context.pushNamed<bool>(EditProfileScreen.id),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('Contact Support'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => context.pushNamed<bool>(ContactSupport.id),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms & Conditions'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
