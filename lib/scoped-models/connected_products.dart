import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProducts on Model {
  List<Product> products = [];
  User authenticateUser;
  int selectedProductIndex;

  void addProduct(String _title, String _description, String _image, double _price) {
    final Product newProduct = Product(
        title: _title,
        description: _description,
        image: _image,
        price: _price,
        userEmail: authenticateUser.email,
        userId: authenticateUser.id);
    products.add(newProduct);
    //selectedProductIndex = null;
    notifyListeners();
  }
}
