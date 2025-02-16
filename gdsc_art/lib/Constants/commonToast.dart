import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

commonToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CustomColors.primaryBrown,
      fontSize: 16.0);
}
