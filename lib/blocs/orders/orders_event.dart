part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrdersEvent {}

class UpdateProducts extends OrdersEvent {
  final List<Orders> ordres;
   final List<Product> products;
  UpdateProducts( this.ordres ,this.products);

  @override
  List<Object> get props => [products];
}
