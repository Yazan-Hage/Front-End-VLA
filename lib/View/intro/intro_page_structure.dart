import 'package:flutter/material.dart';

class IntroPageStructure extends StatelessWidget {
  final String title;
  final String description;
  final IconData image;
  final Color color;
  final String bgImage;

  const IntroPageStructure({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    required this.bgImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5), // طبقة شبه شفافة فوق الخلفية
           padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  image,
                  size: 80,
                  color: color,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}