import 'package:example/domain/dtos/register_param_dto.dart';
import 'package:example/domain/validations/register_param_validation.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final validator = RegisterParamValidation();
  final registerParamDto = RegisterParamDto.empty();

  sucessSnackBar() {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height * 0.8,
        left: 12,
        right: 12,
      ),
      content: const Text('logged in'),
    );
  }

  failureSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red[400],
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height * 0.8,
        left: 12,
        right: 12,
      ),
      content: Text(message),
    );
  }

  void signIn() {
    final errors = validator.validate(registerParamDto);

    if (errors.isEmpty) {
      /// call to api passing the parameter loginParamDto
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackBar());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar(errors.first.message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            ),
            const SizedBox(height: 24),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: registerParamDto.setEmail,
              validator: validator.byField(registerParamDto, 'email'),
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator.byField(registerParamDto, 'phone'),
              onChanged: registerParamDto.setPhone,
              decoration: const InputDecoration(
                hintText: '(11) 99999-9999',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator.byField(registerParamDto, 'password'),
              onChanged: registerParamDto.setPassword,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator.byField(registerParamDto, 'confirmPassword'),
              onChanged: registerParamDto.setConfirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Sign up'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sign In'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
