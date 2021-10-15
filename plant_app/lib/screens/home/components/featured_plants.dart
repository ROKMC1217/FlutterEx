import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/plant.dart';

class FeaturedPlants extends StatelessWidget {
  const FeaturedPlants({
    Key? key,
    this.plants,
  }) : super(key: key);

  final List<Plant>? plants;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // ListView.builder(
          //   itemCount: plants!.length + 1,
          //   itemBuilder: (BuildContext context, int index) {
          //     final actionIndex = index - 1;

          //     return FeaturePlantCard(
          //       image: plants![actionIndex].image,
          //     );
          //   },
          // ),
          FeaturePlantCard(
            image: "assets/images/bottom_img_1.png",
          ),
          FeaturePlantCard(
            image: "assets/images/bottom_img_2.png",
          ),
        ],
      ),
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    Key? key,
    this.image,
  }) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * 0.8,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image!),
          ),
        ),
      ),
    );
  }
}
