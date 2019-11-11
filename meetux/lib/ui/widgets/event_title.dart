import 'package:flutter/material.dart';

import 'package:meetux/model/event.dart';

class EventTitle extends StatelessWidget {
  final Event event;
  final double padding;


  EventTitle(this.event, this.padding,);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            event.name + ' ' + event.printExpired(),
            style: Theme.of(context).textTheme.title,
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                event.getDurationString,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 5.0),
              Icon(Icons.date_range, size: 20.0),
              SizedBox(width: 5.0),

              Text(
                event.getFormatted,
                style: Theme.of(context).textTheme.caption,
               )
            ],
          ),
        ],
      ),
    );
  }
}