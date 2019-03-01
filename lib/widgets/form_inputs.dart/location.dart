import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart' as geoloc;
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
    if (widget.product != null) {
      _getStaticMap(widget.product.location.address, geocode: false);
    }
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

  void _getStaticMap(String address,
      {bool geocode = true, double lat, double lng}) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }
    if (geocode) {
      /* Estou comentando pois não possuo limite de consulta na plataforma do google
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E'});
    final http.Response response = await http.get(uri);
    final decodedResponse = jsonDecode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    //final coords = decodedResponse['results'][0]['geometry']['location']; */

      final formattedAddress = 'R. Indiana, 1140 - Jardim America';
      final coords = {'lat': -19.9461491, 'lng': -43.9738187};

      _locationData = LocationData(
          address: formattedAddress,
          latitude: coords['lat'],
          longitude: coords['lng']);
    } else if (lat == null && lng == null) {
      _locationData = widget.product.location;
    } else {}

    if (mounted) {
      final StaticMapProvider staticMapProvider =
          StaticMapProvider('AIzaSyDGcd1-eDr4GeXV6-ezujkKNxLe5Tw7B0E');
      final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
        Marker('position', 'Position', _locationData.latitude,
            _locationData.longitude)
      ],
          center: Location(_locationData.latitude, _locationData.longitude),
          width: 500,
          height: 300,
          maptype: StaticMapViewType.roadmap);
      widget.setLocation(_locationData);
      setState(() {
        _addressInputController.text = _locationData.address;
        _staticMapUri = staticMapUri;
      });
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': 'AIzaSyCLQTG59usHzrIRrkQwmb8Pzu8OMqsa7ho'
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  void _getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    final address = await _getAddress(
        currentLocation['latitude'], currentLocation['longitude']);
    _getStaticMap(address,
        geocode: false,
        lat: currentLocation['latitude'],
        lng: currentLocation['longitude']);
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
          SizedBox(height: 10.0),
          FlatButton(
            child: Text('Locate User'),
            onPressed: _getUserLocation,
          ),
          SizedBox(
            height: 10.0,
          ),
          _staticMapUri == null
              ? Container()
              : Image.network(_staticMapUri.toString()),
        ],
      ),
    );
  }
}
