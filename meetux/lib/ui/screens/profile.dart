import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget{
  
  final String profilePic;
  final String userName;
  final String userMail;


  
  ProfileScreen(this.profilePic, this.userName,this.userMail);
  
 @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Image.network('$profilePic'),
            Text(this.userName),
            Text(this.userMail),
          ],
        ),
      ),
    );
  }
}
