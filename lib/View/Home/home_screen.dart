import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/name_of_pages.dart';
import '../../controller/auth_controller.dart';
import '../../controller/home_navigator_controller.dart';
import 'containants/home01.dart';
import 'containants/home02.dart';
import 'containants/home03.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> carouselImages = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
    'assets/images/image5.png',
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('تطبيق شهادة القيادة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, Screens.logInScreen);
            },
          )
        ],
      ),
        body: Consumer<NavigationProvider>(
          builder: (context, provider, child) {
            switch (provider.currentIndex) {
              case 0:
                return HomePage(carouselImages: carouselImages);
              case 1:
                return AccidentPage();
              case 2:
                return EducationPage();
              default:
                return HomePage(carouselImages: carouselImages);
            }
          },
        ),
        bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, provider, child) {
            return BottomNavigationBar(
              currentIndex: provider.currentIndex,
              onTap: (index) => provider.currentIndex = index,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_crash),
                  label: 'الإبلاغ عن حادث',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'التعليم',
                ),
              ],
            );
          },
        ),
    );
  }
}
