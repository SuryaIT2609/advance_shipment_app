import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LoginController>();

    return Scaffold(
      body: Form(
        key: c.formKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ERPNext Login",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: c.emailController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              GetBuilder<LoginController>(
                builder: (_) => TextFormField(
                  controller: c.passwordController,
                  obscureText: !c.showPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(c.showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: c.togglePassword,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              GetBuilder<LoginController>(
                builder: (_) => ElevatedButton(
                  onPressed: c.loading ? null : c.login,
                  child: c.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
