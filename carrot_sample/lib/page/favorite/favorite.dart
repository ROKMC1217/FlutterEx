import 'dart:convert';

import 'package:carrot_sample/controller/ListController.dart';
import 'package:carrot_sample/page/detail/detail.dart';
import 'package:carrot_sample/utils/data_utils.dart';
import 'package:carrot_sample/vo/ListVO.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  Map<String, dynamic>? map;
  ListController listController = new ListController();
  Map<String, String>? allValues;
  List<ListVO> vo = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
  }

  Future<List<ListVO>> getLocalStorage() async {
    vo = await listController.readAll();
    return vo;
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "관심목록",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: getLocalStorage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "당근을 불러오지 못했습니다.",
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return DetailContentView(
                          vo: vo[index],
                        );
                      }),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Hero(
                            tag: "${vo[index].no}",
                            child: Image.asset(
                              "${vo[index].image}",
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            height: 100,
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${vo[index].title}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${vo[index].location}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  DataUtils.calcStringToWon(
                                      "${vo[index].price}"),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/heart_off.svg",
                                        width: 13,
                                        height: 13,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("${vo[index].likes}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: vo.length,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 1,
                  color: Colors.black.withOpacity(0.4),
                );
              },
            );
          }
          return Center(
            child: Text("해당 지역에 당근이 없습니다."),
          );
        });
  }

  // Widget _bodyWidget() {
  //   return ListView.separated(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     itemBuilder: (BuildContext context, int index) {
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (BuildContext context) {
  //               return DetailContentView(
  //                 vo: vo[index],
  //               );
  //             }),
  //           );
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 10),
  //           child: Row(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 child: Hero(
  //                   tag: "${vo[index].no}",
  //                   child: Image.asset(
  //                     "${vo[index].image}",
  //                     width: 100,
  //                     height: 100,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   color: Colors.transparent,
  //                   height: 100,
  //                   padding: const EdgeInsets.only(left: 20),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "${vo[index].title}",
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       Text(
  //                         "${vo[index].location}",
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           color: Colors.black.withOpacity(0.3),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       Text(
  //                         DataUtils.calcStringToWon("${vo[index].price}"),
  //                         style: TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       Expanded(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           crossAxisAlignment: CrossAxisAlignment.end,
  //                           children: [
  //                             SvgPicture.asset(
  //                               "assets/svg/heart_off.svg",
  //                               width: 13,
  //                               height: 13,
  //                             ),
  //                             SizedBox(
  //                               width: 5,
  //                             ),
  //                             Text("${vo[index].likes}"),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     itemCount: vo.length,
  //     separatorBuilder: (BuildContext context, int index) {
  //       return Container(
  //         height: 1,
  //         color: Colors.black.withOpacity(0.4),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
