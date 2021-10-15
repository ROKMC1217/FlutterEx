import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/plant.dart';
import 'package:plant_app/screens/details/details_screen.dart';

class RecomendsPlants extends StatelessWidget {
  const RecomendsPlants({
    Key? key,
    this.plants,
  }) : super(key: key);

  final List<Plant>? plants;

  @override
  Widget build(BuildContext context) {
    print("test");
    for (var i = 0; i < plants!.length; i++) {
      print(plants![i].toJson());
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          ListView.builder(
            itemCount: plants!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              print("index!!!!!!!!!!!!!");
              print(index);
              return Scaffold();
              // return RecomendPlantCard(
              //   image: plants![index].image,
              //   country: plants![index].country,
              //   title: plants![index].title,
              //   price: plants![index].price,
              // );
            },
          ),
        ],
      ),
      // child: Row(
      //   children: <Widget>[
      //     RecomendPlantCard(
      //       image: "assets/images/image_1.png",
      //       title: "Samantha",
      //       country: "Russia",
      //       price: 440,
      //     ),
      //     RecomendPlantCard(
      //       image: "assets/images/image_2.png",
      //       title: "Angelica",
      //       country: "Russia",
      //       price: 440,
      //     ),
      //     RecomendPlantCard(
      //       image: "assets/images/image_3.png",
      //       title: "Samantha",
      //       country: "Russia",
      //       price: 440,
      //     ),
      //   ],
      // ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    Key? key,
    this.image,
    this.title,
    this.country,
    this.price,
  }) : super(key: key);

  final String? image, title, country;
  final int? price;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.asset(image!),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    title: title!,
                    country: country!,
                    price: price!,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$title\n".toUpperCase(),
                          style: Theme.of(context).textTheme.button,
                        ),
                        TextSpan(
                          text: "$country",
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
