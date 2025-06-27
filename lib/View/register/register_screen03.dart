// lib/pages/register_step3.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controller/auth_controller.dart';
import '../../model/register_data.dart';


class RegisterStep3Page extends StatefulWidget {
  final RegisterData data;
  const RegisterStep3Page({required this.data});

  @override
  _RegisterStep3PageState createState() => _RegisterStep3PageState();
}

class _RegisterStep3PageState extends State<RegisterStep3Page> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool front) async {
    final src = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('الكاميرا'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('المعرض'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ]),
      ),
    );
    if (src != null) {
      final x = await _picker.pickImage(source: src);
      if (x != null) {
        setState(() {
          final f = File(x.path);
          if (front) widget.data.cardFront = f;
          else      widget.data.cardBack  = f;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (widget.data.cardFront == null || widget.data.cardBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحميل صور البطاقة الأمامية والخلفية')),
      );
      return;
    }
    try {
      final auth = context.read<AuthProvider>();
      await auth.register(
        name: widget.data.name,
        email: widget.data.email,
        password: widget.data.password,
        nationalNumber: widget.data.nationalNumber,
        phone: widget.data.phone,
        dateOfBirth: widget.data.dateOfBirth!,
        bloodType: widget.data.bloodType,
        cardFront: widget.data.cardFront!,
        cardBack: widget.data.cardBack!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التسجيل بنجاح')),
      );
      Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final loading = context.watch<AuthProvider>().loading;
    return Scaffold(
      appBar: AppBar(
        title: const Text("إنشاء حساب - خطوة 3"),
        leading: BackButton(onPressed: () => Navigator.pop(ctx)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPreview(true),
              _buildPreview(false),
            ],
          ),
          const SizedBox(height: 30),
          loading
              ? const CircularProgressIndicator()
              : SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("إنهاء التسجيل", style: TextStyle(fontSize: 20)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildPreview(bool front) {
    final f = front ? widget.data.cardFront : widget.data.cardBack;
    final label = front ? 'أمامية' : 'خلفية';
    return GestureDetector(
      onTap: () => _pickImage(front),
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: f == null
            ? Center(child: Text('اضغط لإضافة $label'))
            : Image.file(f, fit: BoxFit.cover),
      ),
    );
  }
}
