import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/product_model.dart';
import '/repositories/product/base_product_repository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    _firebaseFirestore.settings = const Settings(persistenceEnabled: true);
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
          print(snapshot);
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}
