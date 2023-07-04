import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';

class CustomNavBar extends StatelessWidget {
  final String screen;
  final Product? product;

  const CustomNavBar({
    Key? key,
    required this.screen,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Container(
        height: 70,
        child: (screen == '/product')
            ? AddToCartNavBar(product: product!)
            : (screen == '/cart')
                ? GoToCheckoutNavBar()
                : (screen == '/checkout')
                    ? OrderNowNavBar()
                    :(screen == '/order-confirmation') 
                    ? OrderConfirmation()
                    : HomeNavBar(),
      ),
    );
  }
}

class OrderConfirmation extends StatelessWidget {
  const OrderConfirmation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
      ],
    );
  }
}

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        IconButton(
          icon: Icon(Icons.work_outline_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/orders');
          },
        )
      ],
    );
  }
}

class AddToCartNavBar extends StatelessWidget {
  const AddToCartNavBar({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
        BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return CircularProgressIndicator();
            }
            if (state is WishlistLoaded) {
              return IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to your Wishlist!'),
                    ),
                  );
                  context
                      .read<WishlistBloc>()
                      .add(AddProductToWishlist(product));
                },
              );
            }
            return Text('Something went wrong!');
          },
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return CircularProgressIndicator();
            }
            if (state is CartLoaded) {
              return ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(AddProduct(product));
                  Navigator.pushNamed(context, '/cart');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(),
                ),
                child: Text(
                  'ADD TO CART',
                  style: Theme.of(context).textTheme.headline3,
                ),
              );
            }
            return Text('Something went wrong!');
          },
        ),
      ],
    );
  }
}

class GoToCheckoutNavBar extends StatelessWidget {
  const GoToCheckoutNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return ElevatedButton(
                onPressed: () {
                  if (state.cart.products.length >= 1) {
                    Navigator.pushReplacementNamed(context, '/checkout');
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added More Items!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(),
                ),
                child: Text(
                  'GO TO CHECKOUT',
                  style: Theme.of(context).textTheme.headline3,
                ),
              );
            }
            return Text('Something went wrong!');
          },
        ),
      ],
    );
  }
}

class OrderNowNavBar extends StatelessWidget {
  const OrderNowNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (state is CheckoutLoaded) {
              return ElevatedButton(
                onPressed: () async {
                  if (state.email == null ||
                      state.email == '' ||
                      state.fullName == null ||
                      state.fullName == '' ||
                      state.address == null ||
                      state.address == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('fill in the fields '),
                      ),
                    );
                    //   context.read<CheckoutBloc>().add(
                    //       OrdersNew(),
                    //     );
                    return ;
                  }
                   Navigator.pushReplacementNamed(context, '/order-confirmation');
                },
                style: ElevatedButton.styleFrom(primary: Colors.white),
                child: Text(
                  'ORDER CONFIRMATION',
                  style: Theme.of(context).textTheme.headline3,
                ),
              );

              // if (state.paymentMethod == PaymentMethod.credit_card) {
              //   return Container(
              //     child: Text(
              //       'Pay with Credit Card',
              //       style: Theme.of(context)
              //           .textTheme
              //           .headline4!
              //           .copyWith(color: Colors.white),
              //     ),
              //   );
              // }
              // if (Platform.isAndroid &&
              //     state.paymentMethod == PaymentMethod.google_pay) {
              //   return ElevatedButton(
              //       onPressed: () async {
              //         context.read<CheckoutBloc>().add(
              //               OrdersNew(),
              //             );
              //       },
              //       child: Text('Comprar Productos'));
              // }
              // if (Platform.isIOS &&
              //     state.paymentMethod == PaymentMethod.apple_pay) {
              //   return ElevatedButton(
              //       onPressed: () async {
              //         context.read<CheckoutBloc>().add(
              //               OrdersNew(),
              //             );
              //       },
              //       child: Text('Comprar Productos'));
              // } else {
              //   return ElevatedButton(
              //     onPressed: () async {
              //       context.read<CheckoutBloc>().add(
              //             OrdersNew(),
              //           );
              //       Navigator.pushNamed(context, '/order-confirmation');
              //     },
              //     style: ElevatedButton.styleFrom(primary: Colors.white),
              //     child: Text(
              //       'CHOOSE PAYMENT',
              //       style: Theme.of(context).textTheme.headline3,
              //     ),
              //   );
              // }
            } else {
              return Text('Something went wrong');
            }
          },
        ),
      ],
    );
  }
}
