import 'package:flutter/material.dart';
import 'package:time_counter/models/local_user.dart';
import 'package:time_counter/values/avatars.dart';

Drawer getDrawerHome(BuildContext context, LocalUser localUser) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: Image.asset(
            getAvatarByInt(localUser.avatarId),
          ),
          accountName: Text(localUser.name),
          accountEmail: Text(localUser.email),
          decoration: BoxDecoration(color: Colors.purple),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Configurações"),
        )
      ],
    ),
  );
}
