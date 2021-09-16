import 'package:carrot_sample/vo/ListVO.dart';

abstract class ListService {
  // 글 등록.
  int writeList(ListVO vo);
}
