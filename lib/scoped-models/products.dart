import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductModel extends Model {
  List<Product> _products = [];

  int _selectedProductIndex;

  List<Product> get products {
    return List.from(_products);
  }

  Product getProduct() {
    if (_selectedProductIndex == null) {
      return null;
    }
    return _products[_selectedProductIndex];
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void setProductIndex(int index) {
    _selectedProductIndex = index;
  }

  int getSelectedProductIndex() {
    return _selectedProductIndex;
  }

  void toogleProductFavoriteStatus() {
    final bool isCurrentlyFavorite =
        _products[_selectedProductIndex].isFavorite;
    final bool newFavoriteState = !isCurrentlyFavorite;
    final Product updateProduct = Product(
        title: getProduct().title,
        description: getProduct().description,
        image: getProduct().image,
        price: getProduct().price,
        isFavorite: newFavoriteState);
    _products[_selectedProductIndex] = updateProduct;
    _selectedProductIndex = null;
    notifyListeners();
  }
}
