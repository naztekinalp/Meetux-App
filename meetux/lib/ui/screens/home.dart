
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:meetux/model/event.dart';
import 'package:meetux/ui/widgets/profile_button.dart';
import 'package:meetux/ui/widgets/settings_button.dart';
import 'package:meetux/utils/store.dart';
import 'package:meetux/ui/widgets/event_card.dart';
import 'package:meetux/model/state.dart';
import 'package:meetux/state_widget.dart';
import 'package:meetux/ui/screens/login.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel appState;

  DefaultTabController _buildTabView({Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.code, size: _iconSize)),
                Tab(icon: Icon(Icons.record_voice_over, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: body,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  TabBarView _buildTabsContent() {
    Padding _buildEvents({EventType eventType, List<String> ids}) {
      CollectionReference collectionReference =
      Firestore.instance.collection('events');
      Stream<QuerySnapshot> stream;
      // The argument recipeType is set
      if (eventType != null) {
        stream = collectionReference
            .where("type", isEqualTo: eventType.index)
            .snapshots();
      } else {
        // Use snapshots of all recipes if recipeType has not been passed
        stream = collectionReference.snapshots();
      }

      // Define query depending on passed args
      return Padding(
        // Padding before and after the list view:
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: new StreamBuilder(
                stream: stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _buildLoadingIndicator();
                  return new ListView(
                    children: snapshot.data.documents
                    // Check if the argument ids contains document ID if ids has been passed:
                        .where((d) => ids == null || ids.contains(d.documentID))
                        .map((document) {
                      return new EventCard(
                        event:
                        Event.fromMap(document.data, document.documentID),
                        inFavorites:
                        appState.favorites.contains(document.documentID),
                        onFavoriteButtonPressed: _handleFavoritesListChanged,
                        onShareButtonPressed: _handleShareImage,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      children: [
        _buildEvents(eventType: EventType.workshop),
        _buildEvents(eventType: EventType.seminar),
        _buildEvents(ids: appState.favorites),
        _buildSettings(),

      ],
    );
  }

  // Inactive widgets are going to call this method to
  // signalize the parent widget HomeScreen to refresh the list view:
  void _handleFavoritesListChanged(String eventID) {
    updateFavorites(appState.user.uid, eventID).then((result) {
      // Update the state:
      if (result == true) {
        setState(() {
          if (!appState.favorites.contains(eventID))
            appState.favorites.add(eventID);
          else
            appState.favorites.remove(eventID);
        });
      }
    });
  }

  Future _handleShareImage(String imageURL) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(
          '$imageURL'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Share', 'amlog.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
    }
  }

  Column _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsButton(
          Icons.exit_to_app,
          "Log out from Meetux",
          appState.user.displayName,
              () async {
            await StateWidget.of(context).signOutOfGoogle();
          },
        ),
        ProfileButton(
            appState.user.photoUrl,
            "Show my Profile",
                (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _buildProfileScreen()),
              );
            }
        )
      ],
    );
  }

  Scaffold _buildProfileScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Details'),
        ),
        body: new Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                appState.user.photoUrl)
                        )
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text('Name: ' + appState.user.displayName),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text('E-mail: ' + appState.user.email),
                )
              ],
            ))
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}