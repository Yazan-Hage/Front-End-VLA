// lib/pages/accident_page.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../model/location_model.dart';

class AccidentPage extends StatefulWidget {
  const AccidentPage({super.key});

  @override
  _AccidentPageState createState() => _AccidentPageState();
}

class _AccidentPageState extends State<AccidentPage> {
  String _locationInfo = '';

  Future<void> _getCurrentLocation() async {
    final ctrl = context.read<LocationController>();
    setState(() => _locationInfo = '');

    // 0. Load the logged-in userId
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt(AuthProvider.userIdKey);
    if (storedUserId == null) {
      setState(() {
        _locationInfo =
        'خطأ: لم يتم العثور على معرّف المستخدم. الرجاء تسجيل الدخول مرة أخرى.';
      });
      return;
    }

    try {
      // 1. Request/check permission
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) {
        setState(() {
          _locationInfo =
          'لا يوجد إذن للوصول إلى الموقع. الرجاء تفعيل الإذن من إعدادات الجهاز.';
        });
        return;
      }

      // 2. Get GPS
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Build model
      final locModel = LocationModel(
        userId: storedUserId,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );

      // 4. Report
      await ctrl.reportLocation(locModel);

      // 5. Show result
      if (ctrl.errorMessage != null) {
        print(ctrl.errorMessage);
        setState(() {
          _locationInfo = 'خطأ أثناء الإرسال: ${ctrl.errorMessage}';
        });
      } else {
        final rec = ctrl.locations.first;
        setState(() {
          _locationInfo = 'تم الإرسال بنجاح!\n'
              'الإحداثيات: ${rec.latitude}, ${rec.longitude}\n'
              'وقت التسجيل: ${rec.recordedAt}';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _locationInfo = 'فشل في الحصول على الموقع: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LocationController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('الإبلاغ عن حادث',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(
            'في حالة وقوع حادث مروري، يرجى استخدام هذه الخدمة للإبلاغ الفوري وتحديد موقعك الدقيق. '
                'سيتم إرسال المعلومات مباشرة إلى مركز المرور القريب لتقديم المساعدة اللازمة في أسرع وقت.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 30),
          Text(
            'مهم: هذه الخدمة مخصصة للحوادث البسيطة فقط. '
                'في حالة الحوادث الجسيمة أو الإصابات يرجى الاتصال بالطوارئ مباشرة على الرقم 110',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          ctrl.isLoading
              ? CircularProgressIndicator()
              : ElevatedButton.icon(
            icon: Icon(Icons.location_pin, size: 30),
            label: Text('تحديد موقعي الحالي', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _getCurrentLocation,
          ),
          SizedBox(height: 20),
          if (_locationInfo.isNotEmpty)
            Text(_locationInfo,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          SizedBox(height: 40),
          Icon(Icons.warning_amber, size: 50, color: Colors.orange),
          SizedBox(height: 10),
          Text(
            'سيتم إرسال موقعك إلى أقرب مركز مرور لتقديم المساعدة',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
