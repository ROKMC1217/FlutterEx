import 'package:flutter/material.dart';

class ManorTemperature extends StatelessWidget {
  double? manorTemp;
  int? level;
  final List<Color> temperColors = [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  ManorTemperature({this.manorTemp}) {
    _calcTempLevel();
  }

  void _calcTempLevel() {
    if (this.manorTemp! <= 20) {
      level = 0;
    } else if (this.manorTemp! > 20 && this.manorTemp! <= 32) {
      level = 1;
    } else if (this.manorTemp! > 32 && this.manorTemp! <= 36.5) {
      level = 2;
    } else if (this.manorTemp! > 36.5 && this.manorTemp! <= 40) {
      level = 3;
    } else if (this.manorTemp! > 40 && this.manorTemp! <= 50) {
      level = 4;
    } else if (this.manorTemp! > 40) {
      level = 5;
    }
  }

  Widget _makeTempLabelAndBar() {
    return Container(
      width: 65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${this.manorTemp}°C",
            style: TextStyle(
              color: temperColors[this.level!],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 6,
                    width: 65 / 99 * this.manorTemp!,
                    color: temperColors[this.level!],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _makeTempLabelAndBar(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                width: 30,
                height: 30,
                child: Image.asset("assets/images/level-${level}.jpg"),
              ),
            ],
          ),
          Text(
            "매너온도",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
