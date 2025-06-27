import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/name_of_pages.dart';
import 'intro_page_structure.dart';

class IntroScreens extends StatefulWidget {
  const IntroScreens({Key? key}) : super(key: key);

  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  final PageController _controller = PageController();
  int _currentPage = 0;


  final List<Map<String, dynamic>> introData = [
    {
      'title': "خدمات رخص القيادة",
      'description': "تقديم طلبات رخص القيادة إلكترونياً بكل سهولة",
      'image': Icons.document_scanner,
      'color': Colors.blue,
      'bgImage': 'assets/images/intro1.jpg',
    },
    {
      'title': "الوصول من أي مكان",
      'description': "استخدم التطبيق حتى في المناطق النائية بدون إنترنت",
      'image': Icons.cloud_done,
      'color': Colors.green,
      'bgImage': 'assets/images/intro2.jpeg',
    },
    {
      'title': "تجديد الرخص السريع",
      'description': "جدد رخصتك في دقائق دون زحام أو انتظار",
      'image': Icons.autorenew,
      'color': Colors.orange,
      'bgImage': 'assets/images/intro3.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: introData.map((data) => IntroPageStructure(
              title: data['title'],
              description: data['description'],
              image: data['image'],
              color: data['color'],
              bgImage: data['bgImage'],
            )).toList(),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: introData.length,
                  effect: const SwapEffect(
                    type: SwapType.yRotation,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 15,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      if (_currentPage == introData.length - 1) {
                        // mark intro as seen
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('seen_intro', true);
                        // go to SplashScreen, which will in turn redirect to login/home
                        Navigator.pushReplacementNamed(context, Screens.splashScreen);
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == introData.length - 1
                          ? "ابدأ الآن" : "التالي",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}