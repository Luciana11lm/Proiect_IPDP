import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menu_app/custom_widgets/custom_nav_bar.dart';
import 'package:menu_app/fragments/user/home_fragment_screen.dart';
import 'package:menu_app/fragments/user/order_fragment_screen.dart';
import 'package:menu_app/fragments/user/profile_fragment_screen.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';

class DashboardOfFragments extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile",
    }
  ];

  // current index for selecting pages for each menu element
  final RxInt _indexNumber = 0.obs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
              () => _fragmentScreens[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Obx(
            () => CustomBottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              items: List.generate(3, (index) {
                var navBtnProperty = _navigationButtonsProperties[index];
                return {
                  "non_active_icon": navBtnProperty["non_active_icon"],
                  "active_icon": navBtnProperty["active_icon"],
                  "label": navBtnProperty["label"],
                };
              }),
            ),
            /*Container(
              margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 15, 6),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: BottomNavigationBar(
                  backgroundColor: Colors.orange,
                  currentIndex: _indexNumber.value,
                  onTap: (value) {
                    _indexNumber.value = value;
                  },
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white54,
                  items: List.generate(3, (index) {
                    var navBtnProperty = _navigationButtonsProperties[index];
                    return BottomNavigationBarItem(
                      backgroundColor: const Color.fromARGB(255, 201, 115, 30),
                      icon: Transform.translate(
                        offset: const Offset(0, 20),
                        child: Icon(
                          navBtnProperty["non_active_icon"],
                        ),
                      ),
                      activeIcon: Transform.translate(
                        offset: const Offset(0, 20),
                        child: Icon(
                          navBtnProperty["active_icon"],
                        ),
                      ),
                      label: (navBtnProperty["label"]),
                    );
                  }),
                ),
              ),
            ),*/
          ),
        );
      },
    );
  }
}
