// lib/pages/register_step1.dart
import 'package:flutter/material.dart';
import '../../model/register_data.dart';
import 'register_screen02.dart';


class RegisterStep1Page extends StatefulWidget {
  @override
  _RegisterStep1PageState createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends State<RegisterStep1Page> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    final data = RegisterData()
      ..name = _nameCtl.text.trim()
      ..email = _emailCtl.text.trim()
      ..password = _passCtl.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterStep2Page(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء حساب - خطوة 1")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameCtl,
              decoration: InputDecoration(
                labelText: "الاسم الثلاثي",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (v) =>
              (v == null || v.isEmpty) ? 'لطفاً أدخل اسمك الثلاثي' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailCtl,
              decoration: InputDecoration(
                labelText: "البريد الإلكتروني",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'لطفاً أدخل البريد الإلكتروني';
                if (!v.contains('@')) return 'لطفاً أدخل بريد إلكتروني صحيح';
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passCtl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "كلمة السر",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'لطفاً أدخل كلمة السر';
                if (v.length < 6) return 'يجب أن تكون كلمة السر أكثر من 6 محارف';
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("التالي", style: TextStyle(fontSize: 20)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
