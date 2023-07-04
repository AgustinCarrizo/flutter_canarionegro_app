import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../blocs/blocs.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class OrderConfirmation extends StatelessWidget {
  static const String routeName = '/order-confirmation';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => OrderConfirmation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<CartBloc>()..add(LoadCart());
        context.read<CheckoutBloc>()
          ..add(UpdateCheckout(
            fullName: '',
            email: '',
            city: '',
            country: '',
            zipCode: '',
          ));
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Order Confirmation',
          favorito: false,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: CustomNavBar(screen: routeName),
        extendBodyBehindAppBar: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 300,
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width - 100) / 2,
                    top: 125,
                    child: SvgPicture.asset(
                      'assets/svgs/garlands.svg',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Positioned(
                    top: 250,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Your order is complete!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi Massimo,',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Thank you for purchasing on Zero To Unicorn.',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 20),
                    Text(
                      //'ORDER CODE: #k321-ekd3'
                      'ORDER',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    OrderSummary(),
                    SizedBox(height: 20),
                    Text(
                      'ORDER DETAILS',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if (state is CartLoaded) {
                          Map cart =
                              state.cart.productQuantity(state.cart.products);
                          return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                return ProductCard.cart(
                                  product: cart.keys.elementAt(index),
                                  quantity: cart.values.elementAt(index),
                                  isSummary: true,
                                  isCart: false,
                                );
                              });
                        }
                        return Text('Something went wrong.');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
