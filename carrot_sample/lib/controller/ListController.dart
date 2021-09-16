import 'dart:convert';

import 'package:carrot_sample/service/ListService.dart';
import 'package:carrot_sample/serviceImpl/ListServiceimpl.dart';
import 'package:carrot_sample/vo/ListVO.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListController {
  ListService listService = new ListServiceImpl();
  static final storage = new FlutterSecureStorage();

  // 글 등록.
  int writeList(ListVO vo) {
    return listService.writeList(vo);
  }

  // 로컬스토리지에서 값 가져오기.
  Future<String?> getSotredValue(String key) async {
    try {
      String? value = await storage.read(key: key);
      return value;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // 로컬스토리이제 값 저장.
  Future<void> storeValue(String key, String value) async {
    // value
    try {
      await storage.write(key: key, value: value);
    } catch (error) {
      print(error);
    }
  }

  // 로컬스토리지에 키가 있나 확인
  Future<bool> isMyFavoritecontents(String? key) async {
    // key == no
    String? jsonString = await this.getSotredValue(key!);
    print(jsonString);
    if (jsonString != null) {
      print("로컬스토리지에 값이 있습니다.");
      return true;
    } else {
      print("로컬스토리지에 값이 없습니다.");
      return false;
    }
  }

  // 로컬스토리지에 키에 대한 값을 삭제
  void deleteMyFavoritecontents(String key) async {
    await storage.delete(key: key);
  }

  // Read all values
  Future<List<ListVO>> readAll() async {
    Map<String, String> map = await storage.readAll();
    List<ListVO> vo = List.empty(growable: true);

    map.entries.forEach((element) {
      Map<String, dynamic> voMap = jsonDecode(element.value);
      vo.add(new ListVO(voMap["no"], voMap["image"], voMap["title"],
          voMap["location"], voMap["price"], voMap["likes"]));
    });
    /*
    {
        1: {
              "no":1,
              "image":"assets/images/ara-1.jpg",
              "title":"네메시스 축구화275",
              "location":"제주 제주시 아라동",
              "price":30000,"likes":2
        }, 
        2: {
              "no":2,
              "image":"assets/images/ara-2.jpg",
              "title":"LA갈비 5kg팔아요~",
              "location":"제주 제주시 아라동",
              "price":30000,"likes":5
        }
    }

    */
    return vo;
  }
}
