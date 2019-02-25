import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/ensure-visible.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  GoogleMapController mapController;
  Uri _staticMapUri;
  final FocusNode _addressInputFocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getStaticMap() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 500.0,
              height: 300.0,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  bearing: 270.0,
                  target: LatLng(51.5160895, -0.1294527),
                  tilt: 30.0,
                  zoom: 17.0,
                ),              
               onMapCreated: _onMapCreated,
               myLocationEnabled: true,
               trackCameraPosition: true,
               zoomGesturesEnabled: true,
              ),
            ),
          ),
          RaisedButton(
            child: const Text('Go to London'),
            onPressed: mapController == null ? null : () {
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                const CameraPosition(
                  bearing: 270.0,
                  target: LatLng(41.40338, 2.17403),
                  tilt: 30.0,
                  zoom: 17.0,
                ),
              ));
            },
          ), 
        ],
      ),
    );
/*    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider('AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E');
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', 41.40338, 2.17403)],
        center: Location(41.40338, 2.17403),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    setState(() {
      _staticMapUri = staticMapUri;
    }); */
  }

  void _updateLocation() {}

  void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller; });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          EnsureVisibleWhenFocused(
            focusNode: _addressInputFocusnode,
            child: TextFormField(),
          ),
          SizedBox(
            height: 10.0,
          ),
          getStaticMap(),
        ],
      ),
    );
  }
}
