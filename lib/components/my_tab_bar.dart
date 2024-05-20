import 'package:flutter/material.dart';
import 'package:menu_app/models/food.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;
  const MyTabBar({super.key, required this.tabController});

  List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) {
      return Tab(
        child: Container(
          width: 200,
          height: 20,
          alignment: Alignment.center,
          child: Text(
            category.toString().split('.').last,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PreferredSize(
        preferredSize: Size.fromHeight(0), // Adjust the height as needed
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: ShapeDecoration(
            color: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          controller: tabController,
          tabs: _buildCategoryTabs(),
        ),
      ),
    );
  }
}
