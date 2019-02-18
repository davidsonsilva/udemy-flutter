import '../models/product.dart';
import './connected_products.dart';

mixin ProductModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(products);
  }

  Product getProduct() {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updateProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: getProduct().userEmail,
        userId: getProduct().userId);
    products[selectedProductIndex] = updateProduct;
    //selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    //selectedProductIndex = null;
    notifyListeners();
  }

  void setProductIndex(int index) {
    selectedProductIndex = index;
    if (index != null) {
      notifyListeners();
    }
  }

  int getSelectedProductIndex() {
    return selectedProductIndex;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void toogleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = products[selectedProductIndex].isFavorite;
    final bool newFavoriteState = !isCurrentlyFavorite;
    final Product updateProduct = Product(
        title: getProduct().title,
        description: getProduct().description,
        image: getProduct().image,
        price: getProduct().price,
        userEmail: getProduct().userEmail,
        userId: getProduct().userId,
        isFavorite: newFavoriteState);
    products[selectedProductIndex] = updateProduct;
    //selectedProductIndex = null;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
    selectedProductIndex = null;
  }
}
