import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/products.dart';
import '../scoped-models/user.dart';
import './connected_products.dart';                

class MainModel extends Model with ConnectedProducts, ProductModel, UserModel {}