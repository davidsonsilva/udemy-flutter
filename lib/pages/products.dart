import 'package:flutter/material.dart';

import '../product_manager.dart';
//import './products_admin.dart';

class ProductsPage extends StatelessWidget {

  final List<Map<String, dynamic>> products;
  final Function addProducts;
  final Function deleteProducts;
  ProductsPage(this.products, this.addProducts, this.deleteProducts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('EasyList'),
      ),
      body: ProductManager(products, addProducts, deleteProducts),
    );
  }
}
