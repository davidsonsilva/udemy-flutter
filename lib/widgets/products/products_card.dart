import 'package:flutter/material.dart';
import '../ui_elements/title_default.dart';
import './price_tag.dart';

class ProductsCard extends StatelessWidget {
  
  final Map<String, dynamic> product;
  final int productIndex;

  ProductsCard(this.product, this.productIndex);

  Widget _buildAdressPrice() {
    return Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleDefault(product['title']),
                SizedBox(
                  width: 8.0,
                ),
                PriceTag(product['price'].toString()),
              ],
            ),
          );
  }

  Widget _buildDetailText(){
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(4.0)),
            child: Text('Union Square, San Francisco'),
          );
  }

  Widget _buildActionButtons(BuildContext context){
    return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon:Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + productIndex.toString()),
              ),
              IconButton(
                icon:Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + productIndex.toString()),
              )
            ],
          );
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          _buildAdressPrice(),
          _buildDetailText(),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}