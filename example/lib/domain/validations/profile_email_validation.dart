import 'package:example/domain/dtos/profile_param_dto.dart';
import 'package:lucid_validation/lucid_validation.dart';

/// A small, reusable validator focused only on the e-mail field.
///
/// It is meant to be composed into other validators via `include`, demonstrating
/// `normalize`, `withMessage` and `withErrorCode`.
class ProfileEmailValidation extends LucidValidator<ProfileParamDto> {
  ProfileEmailValidation() {
    ruleFor((dto) => dto.email, key: 'email')
        // #7 normalize: sanitize before validating, without mutating the DTO.
        .normalize((email) => email.trim().toLowerCase())
        .notEmpty()
        // #1 withMessage / withErrorCode customize the previous rule fluently.
        .withMessage('Inform your e-mail')
        .validEmail()
        .withErrorCode('EMAIL_INVALID');
  }
}
