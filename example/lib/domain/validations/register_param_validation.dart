import 'package:example/domain/dtos/register_param_dto.dart';
import 'package:example/domain/validations/extensions.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterParamValidation extends LucidValidation<RegisterParamDto> {
  RegisterParamValidation() {
    ruleFor((registerParamDto) => registerParamDto.email, key: 'email') //
        .notEmpty('This field cannot be empty')
        .validEmail('E-mail in invalid format');

    ruleFor((registerParamDto) => registerParamDto.password, key: 'password') //
        .customValidPassword();

    ruleFor((registerParamDto) => registerParamDto.phone, key: 'phone') //
        .customValidPhone('Phone invalid format');
  }
}
