import 'package:intl/intl.dart';

class DataUtils {
  static final oCcy = new NumberFormat("#,###", "ko_KR");
  static String calcStringToWon(String price) {
    return "${oCcy.format(int.parse(price))}원";
  }
}
