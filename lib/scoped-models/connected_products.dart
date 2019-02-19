import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProducts on Model {
  List<Product> _products = [];
  User _authenticateUser;
  int _selectedProductIndex;

  void addProduct(String _title, String _description, String _image, double _price) {
    final Product newProduct = Product(
        title: _title,
        description: _description,
        image: _image,
        price: _price,
        userEmail: _authenticateUser.email,
        userId: _authenticateUser.id);
    _products.add(newProduct);
    //selectedProductIndex = null;
    notifyListeners();
  }
}

mixin ProductModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  Product get selectedProduct {
    if (_selectedProductIndex == null) {
      return null;
    }
    return _products[_selectedProductIndex];
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    notifyListeners();
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updateProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updateProduct;
    //selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    
    notifyListeners();
  }

  void setProductIndex(int index) {
    _selectedProductIndex = index;
    if (index != null) {
      notifyListeners();
    }
  }

  int get selectedProductIndex {
    return selectedProductIndex;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void toogleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = _products[selectedProductIndex].isFavorite;
    final bool newFavoriteState = !isCurrentlyFavorite;
    final Product updateProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteState);
    _products[selectedProductIndex] = updateProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
    _selectedProductIndex = null;
  }
}

mixin  UserModel on ConnectedProducts {
  void login(String email, String password) {
    _authenticateUser = User(id: 'sdsdfsdf', email: email, password: password);
  }
}
