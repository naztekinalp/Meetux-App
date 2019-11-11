import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:duration/duration.dart';

enum EventType {
  workshop,
  seminar,
}

class Event {
  final String id;
  final EventType type;
  final String name;
  final Duration duration;
  final List<String> requirements;
  final List<String> info;
  final String imageURL;
  final DateTime dateTime;
  final String date;
  final DateTime currentTime;
  final GeoPoint geopoint;


  Event.fromMap(Map<String, dynamic> data, String id)
      : this(
  id: id,
  type: EventType.values[data['type']],
  name: data['name'],
  duration: Duration(minutes: data['duration']),
  requirements: new List<String>.from(data['requirements']),
  info: new List<String>.from(data['info']),
  imageURL: data['image'],
  dateTime: DateTime.utc(data['year'],data['month'],data['day']),
  currentTime: DateTime.now(),
  geopoint: data['geopoint']
  );

  formatDate() {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(this.dateTime);
    return formatted;
  }

  checkDate(){
    int decidedColor;
    if(this.currentTime.isBefore(this.dateTime)){
      decidedColor = 50;
    }
    else {
      decidedColor = 400;
    }
    return decidedColor;
  }

  printExpired(){
    String decidedText;
    if(this.currentTime.isBefore(this.dateTime)){
      decidedText = '';
    }
    else {
      decidedText = '(EXPIRED)';
    }
    return decidedText;
  }

  int get getColor => checkDate();
  String get getTextString => printExpired();

  String get getDurationString => prettyDuration(this.duration);
  String get getFormatted =>  formatDate();


  const Event({
    this.id,
    this.type,
    this.name,
    this.duration,
    this.requirements,
    this.info,
    this.imageURL,
    this.dateTime,
    this.date,
    this.currentTime,
    this.geopoint
  });
}


