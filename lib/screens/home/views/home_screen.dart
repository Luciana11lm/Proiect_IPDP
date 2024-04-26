import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/components/my_silver_app_bar.dart';
import 'package:menu_app/components/restaurant_info.dart';
import 'package:menu_app/components/my_drawer.dart';
import 'package:menu_app/components/my_tab_bar.dart';
import 'package:menu_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:menu_app/components/my_silver_app_bar.dart';

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
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                      children: [
                        Divider(
                          indent: 25,
                          endIndent: 25,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        RestaurantInfo()
                      ],
                    ))
              ],
          body: Container(
            color: Colors.white,
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Text("First tab item"),
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Text("Second tab item"),
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Text("Third tab item"),
                ),
              ],
            ),
          )),
    );
  }
}
