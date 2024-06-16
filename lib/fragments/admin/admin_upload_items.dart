import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menu_app/custom_widgets/custom_nav_bar.dart';
import 'package:menu_app/fragments/admin/admin_orders_fragment.dart';
import 'package:menu_app/fragments/admin/admin_profile_fragment.dart';
import 'package:menu_app/fragments/admin/products_fragment.dart';
import 'package:menu_app/repositories/restaurantPreferences/current_restaurant.dart';

class AdminUploadItems extends StatelessWidget {
  final CurrentRestaurant _rememberCurrentRestaurant =
      Get.put(CurrentRestaurant());
  final List<Widget> _fragmentScreens = [
    ProductsFragmentScreen(),
    AdminOrdersFragment(),
    AdminProfileFragmentScreen(),
  ];

  final List _navigationButtonsProperties = [
    {
      "active_icon": FontAwesomeIcons.burger,
      "non_active_icon": FontAwesomeIcons.pizzaSlice,
      "label": "Products",
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
      init: CurrentRestaurant(),
      initState: (currentState) {
        _rememberCurrentRestaurant.getRestaurantInfo();
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
          ),
        );
      },
    );
  }
}
