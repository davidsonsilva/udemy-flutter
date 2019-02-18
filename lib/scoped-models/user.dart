import '../models/user.dart';
import './connected_products.dart';

mixin  UserModel on ConnectedProducts {
  

  void login(String email, String password) {
    authenticateUser = User(id: 'sdsdfsdf', email: email, password: password);
  }
}
