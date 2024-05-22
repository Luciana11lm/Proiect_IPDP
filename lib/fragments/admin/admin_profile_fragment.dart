import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';
import 'package:menu_app/repositories/userPreferences/user_preferences.dart';
import 'package:menu_app/screens/auth/sign_in_screen.dart';

class AdminProfileFragmentScreen extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Log Out",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: const Text(
          "Are you sure\nyou want to log out?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      // remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(SignInScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String firstNameUser = _currentUser.user.firstName;
    String lastNameUser = _currentUser.user.lastName;
    String passwordUser = _currentUser.user.password;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$firstNameUser $lastNameUser",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        // aici o sa inlocuiesc cu numele restaurantului pentru admin
                        'Food enthusiast and recipe lover',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Favorite Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Numărul de rețete favorite
                itemBuilder: (context, index) {
                  // Afișați aici fiecare rețetă favorită într-un card sau un alt widget
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Text(
                        'Recipe ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Material(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(60),
                child: InkWell(
                  onTap: () {
                    // functia de log out
                    signOutUser();
                  },
                  borderRadius: BorderRadius.circular(60),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text("Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
