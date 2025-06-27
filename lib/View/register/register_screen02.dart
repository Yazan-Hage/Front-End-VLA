// lib/pages/register_step2.dart

import 'package:flutter/material.dart';
import '../../model/register_data.dart';
import 'register_screen03.dart';

class RegisterStep2Page extends StatefulWidget {
  final RegisterData data;
  const RegisterStep2Page({required this.data});

  @override
  _RegisterStep2PageState createState() => _RegisterStep2PageState();
}

class _RegisterStep2PageState extends State<RegisterStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtl = TextEditingController();
  final _natCtl   = TextEditingController();
  String? _bloodType;
  DateTime? _dob;

  final List<String> _bloodOptions = [
    'A+','A-','B+','B-','AB+','AB-','O+','O-'
  ];

  @override
  void dispose() {
    _phoneCtl.dispose();
    _natCtl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _next() {
    if (!_formKey.currentState!.validate() ||
        _bloodType == null ||
        _dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إكمال جميع الحقول')),
      );
      return;
    }

    widget.data.phone          = _phoneCtl.text.trim();
    widget.data.nationalNumber = _natCtl.text.trim();
    widget.data.bloodType      = _bloodType!;
    widget.data.dateOfBirth    = _dob!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterStep3Page(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إنشاء حساب - خطوة 2"),
        leading: BackButton(onPressed: () => Navigator.pop(ctx)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(children: [
            // — Phone
            TextFormField(
              controller: _phoneCtl,
              decoration: InputDecoration(
                labelText: "رقم الجوال",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) =>
              (v == null || v.isEmpty) ? 'لطفاً أدخل رقم الجوال' : null,
            ),
            const SizedBox(height: 20),

            // — National Number
            TextFormField(
              controller: _natCtl,
              decoration: InputDecoration(
                labelText: "الرقم الوطني",
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (v) =>
              (v == null || v.isEmpty) ? 'لطفاً أدخل الرقم الوطني' : null,
            ),
            const SizedBox(height: 20),

            // — Blood Type
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'فصيلة الدم',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _bloodOptions
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              value: _bloodType,
              onChanged: (v) => setState(() => _bloodType = v),
              validator: (v) => v == null ? 'اختر فصيلة الدم' : null,
            ),
            const SizedBox(height: 20),

            // — Date of Birth
            InkWell(
              onTap: _pickDob,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'تاريخ الميلاد',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _dob == null
                      ? 'اختر التاريخ'
                      : '${_dob!.year}-${_dob!.month.toString().padLeft(2,'0')}-${_dob!.day.toString().padLeft(2,'0')}',
                ),
              ),
            ),
            const SizedBox(height: 30),

            // — Next Button
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
