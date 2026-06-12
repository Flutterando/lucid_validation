import 'package:example/domain/dtos/register_param_dto.dart';
import 'package:example/domain/validations/extensions.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterParamValidation extends LucidValidator<RegisterParamDto> {
  RegisterParamValidation() {
    ruleFor((registerParamDto) => registerParamDto.email, key: 'email') //
        // `normalize` sanitizes the value before any rule runs (trim + lowercase),
        // without mutating the original DTO.
        .normalize((email) => email.trim().toLowerCase())
        .notEmpty()
        .withMessage('Digite o seu e-mail')
        .validEmail()
        // `withErrorCode` customizes the code of the previous rule fluently.
        .withErrorCode('EMAIL_INVALID');

    ruleFor((registerParamDto) => registerParamDto.password, key: 'password') //
        .customValidPassword();

    ruleFor((registerParamDto) => registerParamDto.confirmPassword,
            key: 'confirmPassword') //
        .customValidPassword()
        .equalTo((registerParamDto) => registerParamDto.password,
            code: 'passwordEqualTo', message: 'As senhas devem ser iguais');

    ruleFor((registerParamDto) => registerParamDto.phone, key: 'phone') //
        .customValidPhone(message: 'Digite um celular valido');
  }
}
