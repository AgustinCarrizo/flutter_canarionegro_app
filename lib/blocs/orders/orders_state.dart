part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class ProductLoading extends OrdersState {}

class ProductLoaded extends OrdersState {
  final List<Orders> ordres;
  final List<Product> products;
  ProductLoaded({this.products = const <Product>[] , this.ordres = const<Orders>[]});

  @override
  List<Object> get props => [products];
}
