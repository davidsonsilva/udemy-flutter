import 'package:flutter/material.dart';
import './product_edit.dart';

class ProductListPage extends StatelessWidget {
  final Function deleteProduct;
  final Function updateProduct;
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //shrinkWrap: true,
      //padding: EdgeInsets.all(10.0),
      //itemExtent: 20.0,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(products[index]['title']),
          direction: DismissDirection.endToStart,
          onDismissed: (DismissDirection direction){
            if(direction == DismissDirection.endToStart){
              deleteProduct(index);
            }
          },
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: new CircleAvatar(
                  backgroundImage: AssetImage(products[index]['image']),
                  //backgroundColor: Colors.transparent,
                  //child: new Image.asset(products[index]['image']),
                ),
                title: Text(products[index]['title']),
                subtitle: Text('\$${products[index]['price'].toString()}'),
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
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
