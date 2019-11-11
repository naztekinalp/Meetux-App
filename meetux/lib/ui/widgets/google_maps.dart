
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meetux/model/event.dart';
import 'package:random_string/random_string.dart';

class MapView extends StatefulWidget {
  final Event event;

  MapView(this.event);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final CameraPosition _eventPosition = CameraPosition(
      target: LatLng(
          widget.event.geopoint.latitude, widget.event.geopoint.longitude),
      zoom: 15,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Event Location'),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _eventPosition,
              //   trackCameraPosition: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
            ),
            Positioned(
                bottom: 50,
                right: 10,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () => _addMarker()
                ))
          ],
        ));
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  _addMarker() {
    var markerIdVal = randomNumeric(5);
    final MarkerId markerId = MarkerId(markerIdVal);
    String placeName = widget.event.name;
    var marker = Marker(
        markerId: markerId,
        position: LatLng(
            widget.event.geopoint.latitude, widget.event.geopoint.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: placeName, snippet: 'Press GoogleMaps Icon to see on GoogleMaps'),
        draggable: false);

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
