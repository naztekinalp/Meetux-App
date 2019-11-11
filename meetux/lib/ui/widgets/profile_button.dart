import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String profilePic;
  final String title;
  final Function onPressed;

  ProfileButton(this.profilePic, this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: const Color(0xFF807a6b),
      padding: EdgeInsets.all(20.0),
      onPressed: this.onPressed,
      child: Row(
        children: <Widget>[
          Image.network(
            '$profilePic',
            width: 20.0,
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.title),
              SizedBox(height: 5.0),
            ],
          ),
        ],
      ),
    );
  }
}