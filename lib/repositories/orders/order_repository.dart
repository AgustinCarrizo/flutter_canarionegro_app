import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/repositories/notification.dart';
import 'package:ecommerce/repositories/orders/base_order_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OrderRepository extends BaseOrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addOrder(Orders checkout) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    checkout.customerId = await messaging.getToken(
      vapidKey: "394544889657",
    );
    await _firebaseFirestore.collection('orders').add(checkout.toMap());
    await NotificationFMC().sennotification();
    return;
  }

  @override
  Stream<List<Orders>> getOrders(String filter) {
    return _firebaseFirestore
        .collection('orders')
        .where('customerId', isEqualTo: filter)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }
}
