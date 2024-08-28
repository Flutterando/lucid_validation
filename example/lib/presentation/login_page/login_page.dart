import 'package:example/domain/dtos/login_param_dto.dart';
import 'package:example/domain/validations/login_param_validation.dart';
import 'package:example/main.dart';
import 'package:example/presentation/register_page/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final validator = LoginParamValidation();
  final loginParamDto = LoginParamDto.empty();
  final formKey = GlobalKey<FormState>();

  void signIn() {
    final snackBarSuccess = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height * 0.8,
        left: 12,
        right: 12,
      ),
      content: const Text('logged in'),
    );

    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Is English'),
              ValueListenableBuilder<Locale>(
                  valueListenable: globalLocale,
                  builder: (context, _, __) {
                    return Switch(
                      value: globalLocale.value.languageCode == 'en',
                      onChanged: (value) {
                        globalLocale.value = value ? Locale('en', 'US') : Locale('pt', 'BR');
                      },
                    );
                  }),
            ],
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              const SizedBox(height: 24),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: loginParamDto.setEmail,
                validator: validator.byField(loginParamDto, 'email'),
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: loginParamDto.setPassword,
                validator: validator.byField(loginParamDto, 'password'),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: signIn,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Sign up'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
