import 'package:example/domain/dtos/login_param_dto.dart';
import 'package:example/domain/validations/extensions.dart';
import 'package:lucid_validation/lucid_validation.dart';

class LoginParamValidation extends LucidValidation<LoginParamDto> {
  LoginParamValidation() {
    ruleFor((loginParamDto) => loginParamDto.email, key: 'email') //
        .notEmpty()
        .validEmail();

    ruleFor((loginParamDto) => loginParamDto.password, key: 'password') //
        .customValidPassword();
  }
}
