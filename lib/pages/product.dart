import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';

import '../scoped-models/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {

  final Product product;

  ProductPage(this.product);

  _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you shure ?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back buttom pressed !');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(product.image),
                  height: 300.0,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/food.jpg'),
                ),
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TitleDefault(product.title),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          product.description,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: Text(
                          '\$${product.price}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Oswald'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.delete),
                    onPressed: () => _showAlertDialog(
                        context), //=> Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
