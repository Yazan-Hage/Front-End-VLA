// lib/pages/home_page.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';
import '../../../model/request_model.dart';
import '../../../services/request_service.dart';


class HomePage extends StatefulWidget {
  final List<String> carouselImages;
  const HomePage({super.key, required this.carouselImages});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPosting = false;

  Future<void> _handleRequest(String type, String successMsg) async {
    // 1) Grab the live token from your AuthProvider
    final auth = context.read<AuthProvider>();
    final token = auth.token ?? '';
    final svc = RequestService(token: token);

    setState(() => _isPosting = true);
    try {
      // 2) Create the request
      final id = await svc.createRequest(type);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$successMsg (ID: $id)')),
      );
      // 3) Refresh the inline requests list
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}')),
      );
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drivingTips = [
      'حافظ على مسافة أمان لا تقل عن 3 ثواني بينك وبين السيارة الأمامية',
      'تأكد من ضبط المرايا قبل بدء القيادة',
      'استخدم إشارات الانعطاف قبل 30 متر على الأقل من المنعطف',
      'لا تستخدم الهاتف أثناء القيادة تحت أي ظرف',
      'تأكد من صلاحية الإطارات وضغط الهواء بشكل دوري',
      'استخدم الكرسي الخاص بالأطفال لمن هم دون الـ12 سنة',
      'تجنب القيادة عند الشعور بالتعب أو النعاس',
    ];

    // Grab token once for the FutureBuilder call
    final token = context.watch<AuthProvider>().token ?? '';
    final svc = RequestService(token: token);

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1) Image Carousel
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              viewportFraction: 0.9,
            ),
            items: widget.carouselImages.map((img) {
              return Builder(builder: (ctx) {
                return Container(
                  width: MediaQuery.of(ctx).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(img),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                );
              });
            }).toList(),
          ),

          const SizedBox(height: 20),

          // 2) Driving Tips Carousel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'نصائح مرورية هامة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 100,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                  ),
                  items: drivingTips.map((tip) {
                    return Builder(builder: (ctx) {
                      return Container(
                        width: MediaQuery.of(ctx).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[100]!),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                color: Colors.amber[700], size: 30),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // 3) I “طلباتك” Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'طلباتك',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<RequestWithUser>>(
                  future: svc.fetchUserRequests(),
                  builder: (ctx, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('خطأ: ${snap.error}'));
                    }
                    final requests = snap.data!;
                    if (requests.isEmpty) {
                      return const Text('لا توجد طلبات حتى الآن');
                    }
                    return Column(
                      children: requests.map((r) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(
                              r.licenseType == 'new'
                                  ? Icons.add_card
                                  : r.licenseType == 'renewal'
                                  ? Icons.autorenew
                                  : Icons.announcement,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '#${r.requestId} — ${r.licenseType}',
                            ),
                            subtitle: Text(
                              'الحالة: ${r.status}\n'
                                  'قدم بتاريخ: ${r.createdAt.toLocal().toString().split('.')[0]}',
                            ),
                            isThreeLine: true,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4) Service Buttons
          _buildServiceButton(
            title: 'اصدار رخصة قيادة جديدة',
            description:
            'إصدار رخصة جديدة للمرة الأولى. يتطلب مستندات: صورة شخصية، شهادة صحية، هوية سارية. المدّة: 3 أيام عمل.',
            icon: Icons.directions_car,
            color: Colors.blue,
            onPressed: _isPosting
                ? null
                : () => _handleRequest(
              'new',
              'تم إنشاء طلب إصدار رخصة جديدة بنجاح',
            ),
          ),

          _buildServiceButton(
            title: 'تجديد رخصة قيادة منتهية الصلاحية',
            description:
            'تجديد رخصة منتهية الصلاحية. يجب أن تكون منتهية أقل من سنة. المدّة: 24 ساعة.',
            icon: Icons.update,
            color: Colors.green,
            onPressed: _isPosting
                ? null
                : () => _handleRequest(
              'renewal',
              'تم إنشاء طلب تجديد رخصة بنجاح',
            ),
          ),

          _buildServiceButton(
            title: 'اصدار بدل ضائع لرخصة القيادة',
            description:
            'إصدار بدل ضائع. يتطلب بلاغ فقد من الجهات المختصة. المدّة: 48 ساعة.',
            icon: Icons.announcement,
            color: Colors.orange,
            onPressed: _isPosting
                ? null
                : () => _handleRequest(
              'replacement',
              'تم إنشاء طلب بدل ضائع بنجاح',
            ),
          ),

          const SizedBox(height: 20),

          // 5) Footer Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'يقدم التطبيق خدمات إلكترونية متكاملة توفر أكثر من 80% من وقت المواطن وتقلل التكاليف التشغيلية بنسبة 60%، مع ضمان دقة البيانات وتجنب الأخطاء البشرية',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'تم تطوير هذا التطبيق بناءً على دراسة متعمقة لاحتياجات المواطنين وخاصة سكان المناطق النائية وذوي الاحتياجات الخاصة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              icon: Icon(icon, size: 30, color: Colors.white),
              label: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          const Divider(thickness: 1, height: 10),
        ],
      ),
    );
  }
}
