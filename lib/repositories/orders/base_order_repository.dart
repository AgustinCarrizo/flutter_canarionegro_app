import '/models/models.dart';

abstract class BaseOrderRepository {
  Future<void> addOrder(Orders checkout);
  Stream<List<Orders>> getOrders(String filter);
}
