import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meetux/model/event.dart';
import 'package:meetux/ui/widgets/event_title.dart';
import 'package:meetux/model/state.dart';
import 'package:meetux/state_widget.dart';
import 'package:meetux/ui/widgets/google_maps.dart';
import 'package:meetux/utils/store.dart';
import 'package:meetux/ui/widgets/event_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class DetailScreen extends StatefulWidget {
  final Event event;
  final bool inFavorites;

  DetailScreen(this.event, this.inFavorites);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
  StateModel appState;
  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      sampleImage = tempImage;
    });

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content:
                const Text('To see your image, please check Image section'),
            actions: <Widget>[
              FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _scrollController = ScrollController();
    _inFavorites = widget.inFavorites;
  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      _inFavorites = !_inFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    EventImage(widget.event.imageURL),
                    EventTitle(widget.event, 25.0),
                  ],
                ),
              ),
              expandedHeight: 340.0,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(text: "Requirements"),
                  Tab(text: "Information"),
                  Tab(text: "Image"),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            RequirementsView(widget.event.requirements),
            InfoView(widget.event.info),
            Center(
              child: sampleImage == null
                  ? Text('Select an image')
                  : enableUpload(),
            )
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              updateFavorites(appState.user.uid, widget.event.id)
                  .then((result) {
                // Toggle "in favorites" if the result was successful.
                if (result) _toggleInFavorites();
              });
            },
            child: Icon(
              _inFavorites ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).iconTheme.color,
            ),
            elevation: 2.0,
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: 5.0,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new MapView(widget.event),
                  ),
                ),
            child: Icon(
              Icons.location_on,
              color: Theme.of(context).iconTheme.color,
            ),
            backgroundColor: Colors.white,
            elevation: 2.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          FloatingActionButton(
            heroTag: "btn3",
            onPressed: getImage,
            child: Icon(
              Icons.add_a_photo,
              color: Theme.of(context).iconTheme.color,
            ),
            backgroundColor: Colors.white,
            elevation: 2.0,
          )
        ],
      ),
    );
  }

  Widget enableUpload() {
    return Container(
        child: Column(
      children: <Widget>[
        Image.file(sampleImage, height: 300.0, width: 300.0),
        RaisedButton(
          elevation: 7.0,
          child: Text('Upload'),
          textColor: Theme.of(context).iconTheme.color,
          color: Colors.white,
          onPressed: () {
            final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child(randomNumeric(8));
            final StorageUploadTask task =
                firebaseStorageRef.putFile(sampleImage);
            return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Alert'),
                    content: const Text(
                        'Your image has been uploaded succesfully'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  );
                });
          },
        )
      ],
    ));
  }
}

class RequirementsView extends StatelessWidget {
  final List<String> requirements;

  RequirementsView(this.requirements);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    requirements.forEach((item) {
      children.add(
        new Row(
          children: <Widget>[
            new Icon(Icons.done),
            new SizedBox(width: 5.0),
            new Text(item),
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        new SizedBox(
          height: 5.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}

class InfoView extends StatelessWidget {
  final List<String> infoSteps;

  InfoView(this.infoSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = List<Widget>();
    infoSteps.forEach((item) {
      textElements.add(
        Text(item),
      );
      // Add spacing between the lines:
      textElements.add(
        SizedBox(
          height: 10.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}
