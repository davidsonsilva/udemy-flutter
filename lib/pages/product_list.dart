import 'package:flutter/material.dart';
import './product_edit.dart';

class ProductListPage extends StatelessWidget {
  final Function updateProduct;
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //shrinkWrap: true,
      //padding: EdgeInsets.all(10.0),
      //itemExtent: 20.0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.transparent,
            child: new Image.asset(products[index]['image']),
          ),
          title: Text(products[index]['title']),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProductEditPage(
                      product: products[index],
                      updateProduct: updateProduct,
                      productIndex: index,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
