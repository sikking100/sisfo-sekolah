import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/auth_controller.dart';

class PageAuth extends StatelessWidget {
  const PageAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: GetX<AuthController>(
            init: AuthController(),
            builder: (controller) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Selamat Datang', style: Theme.of(context).textTheme.headline3),
                Text('Silakan Login', style: Theme.of(context).textTheme.headline6),
                Divider(color: Theme.of(context).primaryColor),
                const SizedBox(height: 30),
                TextField(
                  controller: controller.email,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextField(
                  controller: controller.password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    prefixIcon: Icon(Icons.password),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.login,
                        child: controller.isLoading.value ? const CircularProgressIndicator() : const Text('Login')),
                    ElevatedButton(
                        onPressed: controller.isLoadingForgetPassword.value ? null : controller.forgetPassword,
                        child: controller.isLoadingForgetPassword.value
                            ? const CircularProgressIndicator()
                            : const Text('Lupa Password')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
