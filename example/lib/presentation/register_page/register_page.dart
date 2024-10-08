import 'package:example/domain/dtos/register_param_dto.dart';
import 'package:example/domain/validations/register_param_validation.dart';
import 'package:example/main.dart';
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
    final result = validator.validate(registerParamDto);

    if (result.isValid) {
      /// call to api passing the parameter loginParamDto
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackBar());
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(failureSnackBar(result.exceptions.first.message));
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
                        globalLocale.value =
                            value ? Locale('en', 'US') : Locale('pt', 'BR');
                      },
                    );
                  }),
            ],
          )
        ],
      ),
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
            ListenableBuilder(
              listenable: registerParamDto,
              builder: (context, child) {
                final result = validator.validate(registerParamDto);

                return ElevatedButton(
                  onPressed: result.isValid ? signIn : null,
                  child: const Text('Register'),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
