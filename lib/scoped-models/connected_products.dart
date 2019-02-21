import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productsData = {
      'title': title,
      'description': description,
      'image':
          'http://pratocheio.org.br/wp-content/uploads/2015/03/Chocolate.jpg',
      'price': price,
      'userEmail': _authenticatedUser == null
          ? 'teste@gmail.com'
          : _authenticatedUser.email,
      'userId': _authenticatedUser == null ? '123456' : _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post(
          'https://flutter-products-21b9c.firebaseio.com/products.json',
          body: json.encode(productsData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: responseData['email'],
          userId: responseData['id']);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'http://pratocheio.org.br/wp-content/uploads/2015/03/Chocolate.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-products-21b9c.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final String productId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-21b9c.firebaseio.com/products/${productId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-products-21b9c.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      final Map<String, dynamic> productsData = json.decode(response.body);
      final List<Product> products = [];

      if (productsData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productsData.forEach((String productId, dynamic productsData) {
        final Product productValue = Product(
            id: productId,
            title: productsData['title'],
            description: productsData['description'],
            image: productsData['image'],
            price: productsData['price'],
            userEmail: productsData['userEmail'],
            userId: productsData['userId']);
        products.add(productValue);
      });
      _products = products;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;

    if (authMode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCjzl0yDfAYe0iR_5Ep7LD4lcAkRwrGEH8',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCjzl0yDfAYe0iR_5Ep7LD4lcAkRwrGEH8',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';

    if (responseData.containsKey('idToken')) {
      message = 'Login succeede!';
      hasError = false;
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message =
          'There is no user record corresponding to this identifier. The user may have been deleted.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid or the user does not have a password.';
    } else if (responseData['error']['message'] == 'USER_DISABLED') {
      message = 'The user account has been disabled by an administrator.';
    }

    return {
      'success': !hasError,
      'idToken': responseData['idToken'],
      'message': message
    };
    /* _authenticatedUser =
        User(id: 'fdalsdfasf', email: email, password: password); */
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
