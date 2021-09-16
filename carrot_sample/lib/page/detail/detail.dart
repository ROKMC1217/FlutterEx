import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_sample/controller/ListController.dart';
import 'package:carrot_sample/page/detail/manor_temperature_widget.dart';
import 'package:carrot_sample/utils/data_utils.dart';
import 'package:carrot_sample/vo/ListVO.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailContentView extends StatefulWidget {
  final ListVO? vo;

  DetailContentView({this.vo});

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with TickerProviderStateMixin {
  Size? size;
  List<Map<String, String>>? imgList;
  int? _current;
  double scollpositionToAlpha = 0;
  ScrollController _controller = new ScrollController();
  AnimationController? _animationController;
  Animation? _colorTween;
  bool isMyFavoriteContent = false;
  ListController listController = new ListController();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  void initState() {
    super.initState();
    _current = 0;
    imgList = [
      {"id": "0", "url": "${widget.vo!.image}"},
      {"id": "1", "url": "${widget.vo!.image}"},
      {"id": "2", "url": "${widget.vo!.image}"},
      {"id": "3", "url": "${widget.vo!.image}"},
      {"id": "4", "url": "${widget.vo!.image}"},
    ];
    _loadMyFavoriteContentState();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(_animationController!);

    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scollpositionToAlpha = 255;
        } else {
          scollpositionToAlpha = _controller.offset;
        }
        _animationController!.value = scollpositionToAlpha / 255;
        print(_controller.offset);
      });
    });
  }

  _loadMyFavoriteContentState() async {
    bool check = await listController.isMyFavoritecontents("${widget.vo!.no}");
    setState(() {
      isMyFavoriteContent = check;
    });
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween!,
      builder: (context, child) => Icon(
        icon,
        color: _colorTween!.value,
      ),
    );
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scollpositionToAlpha.toInt()),
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {
            print("search");
          },
          icon: _makeIcon(Icons.share),
        ),
        IconButton(
          onPressed: () {
            print("tune");
          },
          icon: _makeIcon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: "${widget.vo!.no}",
            child: CarouselSlider(
              items: imgList!.map((map) {
                return Image.asset(
                  "${map["url"]}",
                  width: size!.width,
                  fit: BoxFit.fill,
                );
              }).toList(),
              options: CarouselOptions(
                height: size!.width,
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList!.map((map) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == int.parse('${map["id"]}')
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("개발하는남자",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              Text("제주시 도담동"),
            ],
          ),
          Expanded(child: ManorTemperature(manorTemp: 37.5)),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            "${widget.vo!.title}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "디지털/가전 ∙ 22시간 전",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품은 꺼내보기만 했습니다.\n거래는 직거래만 합니다.",
            style: TextStyle(
              height: 1.5,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3 ∙ 관심 17 ∙ 조회 295",
            style: TextStyle(
              height: 1.5,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "모두보기",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildListDelegate(List.generate(20, (index) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey,
                        height: 120.0,
                      ),
                    ),
                    Text(
                      "상품 제목",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "금액",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList()),
          ),
        ),
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size!.width,
      color: Colors.white,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // isMyFavoriteContent이 true면
              if (isMyFavoriteContent) {
                listController.deleteMyFavoritecontents("${widget.vo!.no}");
              } else {
                // isMyFavoriteContent이 false면
                listController.storeValue(
                    "${widget.vo!.no}", jsonEncode(widget.vo!.getJson()));
              }
              setState(() {
                print("관심상품 이벤트 발생");
                isMyFavoriteContent = !isMyFavoriteContent;
              });
              // GlobalKey
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isMyFavoriteContent
                      ? "관심 목록에 추가되었습니다."
                      : "관심 목록에 제거되었습니다."),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: SvgPicture.asset(
              isMyFavoriteContent
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 25,
              height: 25,
              color: Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 15,
              right: 10,
            ),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DataUtils.calcStringToWon("${widget.vo!.price}"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "가격제안불가",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 7),
                    color: Color(0xfff08f4f),
                    child: Text(
                      "채팅으로 거래하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
