import 'package:flutter/material.dart';
import 'package:plant_app/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
    this.title,
    this.country,
    this.price,
  }) : super(key: key);

  final String? title, country;
  final int? price;

  void initState() {
    print(title);
    print(country);
    print(price);
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
      body: Body(
        title: title,
        country: country,
        price: price,
      ),
    );
  }
}
