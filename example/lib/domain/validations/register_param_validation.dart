import 'package:example/domain/dtos/register_param_dto.dart';
import 'package:example/domain/validations/extensions.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterParamValidation extends LucidValidator<RegisterParamDto> {
  RegisterParamValidation() {
    ruleFor((registerParamDto) => registerParamDto.email, key: 'email') //
        .notEmpty()
        .validEmail();

    ruleFor((registerParamDto) => registerParamDto.password, key: 'password') //
        .customValidPassword();

    ruleFor((registerParamDto) => registerParamDto.confirmPassword, key: 'confirmPassword') //
        .customValidPassword()
        .equalTo((registerParamDto) => registerParamDto.password);

    ruleFor((registerParamDto) => registerParamDto.phone, key: 'phone') //
        .customValidPhone();
  }
}
