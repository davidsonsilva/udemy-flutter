import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function deleteProduct;

  Products(this.products, {this.deleteProduct}) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProducttem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(children: <Widget>[
               Text(
              products[index]['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
            ), 
            Text(products[index]['price'].toString())
            ],),
            
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + index.toString()),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    Widget productCard = Center(
      child: Text('No products found.Please add some!'),
    );
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProducttem,
        itemCount: products.length,
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build');
    return _buildProductsList();
  }
}
