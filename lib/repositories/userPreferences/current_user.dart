import 'package:get/state_manager.dart';
import 'package:menu_app/repositories/models/user.dart';
import 'package:menu_app/repositories/userPreferences/user_preferences.dart';

class CurrentUser extends GetxController {
  final Rx<User> _currentUser = User.withId(0, '', '', '', '').obs;
  User get user => _currentUser.value;
  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
