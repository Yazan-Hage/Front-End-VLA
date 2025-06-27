import 'package:flutter/material.dart';

class EducationPage extends StatefulWidget {
  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue[700],
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'قائمة الفيديوهات'),
              Tab(text: 'نصائح سريعة'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // قائمة الفيديوهات
              ListView(
                children: [
                  _buildVideoItem('أساسيات القيادة الآمنة'),
                  _buildVideoItem('كيفية التعامل مع الطرق الزلقة'),
                  _buildVideoItem('إشارات المرور والإلتزام بها'),
                  _buildVideoItem('القيادة في الظروف الجوية الصعبة'),
                  _buildVideoItem('الصيانة الدورية للسيارة'),
                ],
              ),

              // النصائح السريعة
              ListView(
                children: [
                  _buildTipItem('حافظ على مسافة أمان لا تقل عن 3 ثواني بينك وبين السيارة الأمامية'),
                  _buildTipItem('تأكد من ضبط المرايا قبل بدء القيادة'),
                  _buildTipItem('استخدم إشارات الانعطاف قبل 30 متر على الأقل من المنعطف'),
                  _buildTipItem('لا تستخدم الهاتف أثناء القيادة تحت أي ظرف'),
                  _buildTipItem('تأكد من صلاحية الإطارات وضغط الهواء بشكل دوري'),
                  _buildTipItem('استخدم الكرسي الخاص بالأطفال لمن هم دون الـ12 سنة'),
                  _buildTipItem('تجنب القيادة عند الشعور بالتعب أو النعاس'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoItem(String title) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.play_circle_fill, color: Colors.red, size: 40),
        title: Text(title, style: TextStyle(fontSize: 18)),
        subtitle: Text('مدة الفيديو: 15 دقيقة'),
        trailing: Icon(Icons.download),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: Icon(Icons.lightbulb, color: Colors.amber),
        title: Text(tip, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}