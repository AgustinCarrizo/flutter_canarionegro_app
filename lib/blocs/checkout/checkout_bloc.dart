import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/models/payment_method_model.dart';
import 'package:ecommerce/repositories/orders/order_repository.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/checkout/checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CartBloc _cartBloc;
  final PaymentBloc _paymentBloc;
  final CheckoutRepository _checkoutRepository;
  final OrderRepository _orderRepository;
  StreamSubscription? _cartSubscription;
  StreamSubscription? _paymentSubscription;
  StreamSubscription? _checkoutSubscription;

  CheckoutBloc(
      {required CartBloc cartBloc,
      required PaymentBloc paymentBloc,
      required CheckoutRepository checkoutRepository,
      required OrderRepository orderRepository})
      : _cartBloc = cartBloc,
        _paymentBloc = paymentBloc,
        _checkoutRepository = checkoutRepository,
        _orderRepository = orderRepository,
        super(
          cartBloc.state is CartLoaded
              ? CheckoutLoaded(
                  products: (cartBloc.state as CartLoaded).cart.products,
                  deliveryFee:
                      (cartBloc.state as CartLoaded).cart.deliveryFeeString,
                  subtotal: (cartBloc.state as CartLoaded).cart.subtotalString,
                  total: (cartBloc.state as CartLoaded).cart.totalString,
                )
              : CheckoutLoading(),
        ) {
    on<UpdateCheckout>(_onUpdateCheckout);
    on<ConfirmCheckout>(_onConfirmCheckout);
    on<OrdersNew>(_onOrdersNew);

    _cartSubscription = _cartBloc.stream.listen(
      (state) {
        if (state is CartLoaded)
          add(
            UpdateCheckout(cart: state.cart),
          );
      },
    );

    _paymentSubscription = _paymentBloc.stream.listen((state) {
      if (state is PaymentLoaded) {
        add(
          UpdateCheckout(paymentMethod: state.paymentMethod),
        );
      }
    });
  }

  void _onUpdateCheckout(
    UpdateCheckout event,
    Emitter<CheckoutState> emit,
  ) {
    if (this.state is CheckoutLoaded) {
      final state = this.state as CheckoutLoaded;
      emit(
        CheckoutLoaded(
          email: event.email ?? state.email,
          fullName: event.fullName ?? state.fullName,
          products: event.cart?.products ?? state.products,
          deliveryFee: event.cart?.deliveryFeeString ?? state.deliveryFee,
          subtotal: event.cart?.subtotalString ?? state.subtotal,
          total: event.cart?.totalString ?? state.total,
          address: event.address ?? state.address,
          city: event.city ?? state.city,
          country: event.country ?? state.country,
          zipCode: event.zipCode ?? state.zipCode,
          paymentMethod: event.paymentMethod ?? state.paymentMethod,
        ),
      );
    }
  }

  void _onConfirmCheckout(
    ConfirmCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    _checkoutSubscription?.cancel();
    if (this.state is CheckoutLoaded) {
      try {
        await _checkoutRepository.addCheckout(event.checkout);
        print('Done');
        emit(CheckoutLoading());
      } catch (_) {}
    }
  }

  void _onOrdersNew(
    OrdersNew event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoaded());
    try {
      var lisprod = (_cartBloc.state as CartLoaded).cart;
      var stringliste = <String>[];
      Map cart = lisprod.productQuantity(lisprod.products);
      int i = 0;
      List<Map<String, Object>> map = [];
      var listaSinRepetidos = List.from(lisprod.products.toSet());

      for (var e in listaSinRepetidos) {
        var newdate = <String, Object>{
          'id': e.id,
          'value': cart.values.elementAt(i).toString()
        };
         map.add(newdate);
        print(map);
        i++;
        
      }

      var newOrder = Orders(
          id: 1,
          customerId: '',
          productIds: map,
          deliveryFee: double.parse(
              (_cartBloc.state as CartLoaded).cart.deliveryFeeString),
          subtotal:
              double.parse((_cartBloc.state as CartLoaded).cart.subtotalString),
          total: double.parse((_cartBloc.state as CartLoaded).cart.totalString),
          isAccepted: false,
          isDelivered: false,
          isCancelled: false,
          createdAt: DateTime.now());
      await _orderRepository.addOrder(newOrder);
      print('Done');
      emit(CheckoutLoading());
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}

class ValueDate {
  final String id;
  final String value;
  ValueDate({required this.id, required this.value});

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'value': value,
    };
  }
}
