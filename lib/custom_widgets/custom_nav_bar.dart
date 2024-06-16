import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Map<String, dynamic>> items;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.orange,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            int index = entry.key;
            var navBtnProperty = entry.value;

            return GestureDetector(
              onTap: () => onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 2),
                    child: Icon(
                      currentIndex == index
                          ? navBtnProperty["active_icon"]
                          : navBtnProperty["non_active_icon"],
                      color:
                          currentIndex == index ? Colors.white : Colors.white54,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 4),
                    child: Text(
                      navBtnProperty["label"],
                      style: TextStyle(
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
