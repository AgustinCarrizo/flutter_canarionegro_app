import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/repositories/orders/order_repository.dart';
import 'package:ecommerce/repositories/product/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '/models/models.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;
  StreamSubscription? _orderSubscription;
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  OrdersBloc(
      {required OrderRepository orderRepository,
      required ProductRepository productRepository})
      : _orderRepository = orderRepository,
        _productRepository = productRepository,
        super(ProductLoading()) {
    on<LoadOrders>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
  }

  void _onLoadProducts(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    _orderSubscription?.cancel();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var filter = await messaging.getToken(
      vapidKey: "394544889657",
    );
    List<Product> listProducts = [];
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
      (products) {
        listProducts = products;
        _orderSubscription = _orderRepository.getOrders(filter ?? '').listen(
              (ordres) => add(
                UpdateProducts(ordres, listProducts),
              ),
            );
      },
    );
  }

  void _onUpdateProducts(
    UpdateProducts event,
    Emitter<OrdersState> emit,
  ) {
    emit(ProductLoaded(ordres: event.ordres, products: event.products));
  }
}
