import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/components/my_food_tile.dart';
import 'package:menu_app/components/my_silver_app_bar.dart';
import 'package:menu_app/components/restaurant_info.dart';
import 'package:menu_app/components/my_drawer.dart';
import 'package:menu_app/components/my_tab_bar.dart';
import 'package:menu_app/models/food.dart';
import 'package:menu_app/models/restaurant.dart';
import 'package:menu_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:menu_app/components/my_silver_app_bar.dart';
import 'package:menu_app/screens/home/views/food_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  List<Widget> getFoodInthisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return FoodTile(
            food: food,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodScreen(food: food),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            MySilverAppBar(
                title: MyTabBar(tabController: _tabController),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  /*children: [
                    Divider(
                      indent: 25,
                      endIndent: 25,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    RestaurantInfo()
                  ],*/
                ))
          ],
          body: Consumer<Restaurant>(
              builder: (context, restaurnat, child) => Container(
                    color: Colors.white,
                    child: TabBarView(
                        controller: _tabController,
                        children: getFoodInthisCategory(restaurnat.menu)),
                  )),
        ));
  }
}
