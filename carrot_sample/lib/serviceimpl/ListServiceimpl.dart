import 'package:carrot_sample/service/ListService.dart';
import 'package:carrot_sample/vo/ListVO.dart';
import 'package:carrot_sample/dao/ListDAO.dart';

class ListServiceImpl implements ListService {
  ListDAO dao = new ListDAO();
  // 글 등록.
  @override
  int writeList(ListVO vo) {
    return dao.writeList(vo);
  }
}
