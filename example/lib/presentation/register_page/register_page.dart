import 'package:example/domain/dtos/register_param_dto.dart';
import 'package:example/domain/validations/register_param_validation.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final validator = RegisterParamValidation();
  final registerParamDto = RegisterParamDto.empty();
  final exceptionsPassword = ValueNotifier<List<String>>([]);

  @override
  initState() {
    super.initState();

    _checkPasswordValidation();
  }

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

  void _checkPasswordValidation() {
    final exceptionsListPassword = validator.getExceptionsByKey(
      registerParamDto,
      'password',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      exceptionsPassword.value =
          exceptionsListPassword.map((e) => e.code).toList();

    });
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
              validator: (value) {
                _checkPasswordValidation();
                return null;
              },
              onChanged: registerParamDto.setPassword,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: exceptionsPassword,
              builder: (context, exceptionsPassword, _) {
                return PasswordRequirements(errors: exceptionsPassword);
              },
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

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key, required this.errors});

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> requirementsMap = {
      Language.code.minLength: 'Pelo menos 8 caracteres',
      Language.code.mustHaveUppercase: 'Pelo menos uma letra maiúscula',
      Language.code.mustHaveLowercase: 'Pelo menos uma letra minúscula',
      Language.code.mustHaveNumber: 'Pelo menos um número',
      Language.code.mustHaveSpecialCharacter:
          'Pelo menos um caractere especial (@\$!%*#?&)',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirementsMap.entries.map((entry) {
        var colorIcon = Colors.lightGreen;

        if (errors.contains(entry.key)) {
          colorIcon = Colors.red;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            spacing: 4.0,
            children: [
              Icon(Icons.warning, size: 12.0, color: colorIcon),
              Text(entry.value),
            ],
          ),
        );
      }).toList(),
    );
  }
}
