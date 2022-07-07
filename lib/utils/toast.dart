import 'package:care_giver/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  if (message.isNotEmpty) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: COLORS.toast_background_color,
        textColor: COLORS.white);
  }
}
