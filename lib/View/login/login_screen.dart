import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/name_of_pages.dart';
import '../../controller/auth_controller.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    final auth = ctx.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل الدخول"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
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
                    if (v == null || v.isEmpty) {
                      return 'لطفاً أدخل البريد الإلكتروني';
                    }
                    if (!v.contains('@')) {
                      return 'لطفاً أدخل بريد إلكتروني صحيح';
                    }
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
                    if (v == null || v.isEmpty) {
                      return 'لطفاً أدخل كلمة السر';
                    }
                    if (v.length < 6) {
                      return 'يجب أن تكون كلمة السر أكثر من 6 محارف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                auth.loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      try {
                        await auth.login(
                          email: _emailCtl.text.trim(),
                          password: _passCtl.text,
                        );
                        Navigator.pushReplacementNamed(
                            ctx, Screens.homeScreen);
                      } catch (err) {
                        print(err);
                        ScaffoldMessenger.of(ctx)
                            .showSnackBar(
                          SnackBar(
                            content: Text(err.toString(),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("LOGIN",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(ctx, Screens.registerScreen);
                  },
                  child: const Text("انشئ حساب جديد"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
