import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../helpers/ensure-visible.dart';
import '../../models/location_data.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LocationData _locationData;
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
      getStaticMap(_addressInputController.text);
    }
  }

  void getUriForAddress(String address) async {
    if (address.isEmpty) {
      widget.setLocation(null);
      return;
    }

    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E'});
    final http.Response response = await http.get(uri);
    final decodedResponse = jsonDecode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];

    _locationData = LocationData(
        address: formattedAddress,
        latitude: coords['lat'],
        longitude: coords['lng']);

    widget.setLocation(_locationData);
  }

  void getStaticMap(String address) async {

    if (address.isEmpty) {
      widget.setLocation(null);
      return;
    }
    /* Estou comentando pois não possuo limite de consulta na plataforma do google
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E'});
    final http.Response response = await http.get(uri);
    final decodedResponse = jsonDecode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    //final coords = decodedResponse['results'][0]['geometry']['location']; */

    final formattedAddress = 'R. Indiana, 1140 - Jardim America';
    final coords = {'lat':-19.9461491, 'lng':-43.9738187};

    

    _locationData = LocationData(
        address: formattedAddress,
        latitude: coords['lat'],
        longitude: coords['lng']);

    widget.setLocation(_locationData);

    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E');
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', _locationData.latitude, _locationData.longitude)],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    setState(() {
      _addressInputController.text = formattedAddress;
      _staticMapUri = staticMapUri;
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
              validator: (String value) {
                if (_locationData == null || value.isEmpty) {
                  return 'No valid location found!';
                }
              },
              decoration: InputDecoration(labelText: 'Address'),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _addressInputController.text.isEmpty
              ? Container()
              : Image.network(_staticMapUri.toString()),
        ],
      ),
    );
  }
}
