import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../helpers/ensure-visible.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  GoogleMapController mapController;
  Uri _staticMapUri;

  final FocusNode _addressInputFocusnode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusnode.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusnode.removeListener(_updateLocation);
    super.dispose();
  }

  void _updateLocation() {
    if (!_addressInputFocusnode.hasFocus) {
      getUriForAddress(_addressInputController.text);
      getStaticMap();
    }
  }

  void getUriForAddress(String address) async {
    if (address.isEmpty) {
      return;
    }

    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E'});
    final http.Response response = await http.get(uri);
    final decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    //final formattedAddress = decodedResponse['results'][0]['formatted_address'];

    //location: {lat: -19.9461491, lng: -43.97163}

    //print(formattedAddress);
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
                  zoom: 10.0,
                ),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                trackCameraPosition: true,
                zoomGesturesEnabled: true,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text('Go to address'),
            textColor: Colors.white,
            onPressed: mapController == null
                ? null
                : () {
                    //Add Marker on Map
                    mapController.addMarker(MarkerOptions(
                      position: LatLng(41.40338, 2.17403),
                      draggable: false,
                    ));
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          EnsureVisibleWhenFocused(
            focusNode: _addressInputFocusnode,
            child: TextFormField(
              focusNode: _addressInputFocusnode,
              controller: _addressInputController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
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
