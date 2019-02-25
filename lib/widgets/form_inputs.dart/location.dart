import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import '../helpers/ensure-visible.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

final FocusNode _addressInputFocusnode =FocusNode();

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

  void _updateLocation(){

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          EnsureVisibleWhenFocused(
            focusNode:_addressInputFocusnode ,
            child: TextFormField(

            ),
          )
        ],
      ),
    );
  }
}
