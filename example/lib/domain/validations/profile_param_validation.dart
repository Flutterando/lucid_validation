import 'package:example/domain/dtos/profile_param_dto.dart';
import 'package:example/domain/repositories/user_repository.dart';
import 'package:example/domain/validations/profile_email_validation.dart';
import 'package:lucid_validation/lucid_validation.dart';

/// Rule set executed only when the form is submitted (it contains async rules).
const submitRuleSet = 'submit';

/// Validator for the "Company / Profile" form.
///
/// Showcases the 1.4.0 features:
///   #1 withMessage / withErrorCode / withName
///   #2 mustAsync (run with validateAsync)
///   #3 ruleForEach
///   #4 ruleSet
///   #5 include
///   #6 unless
///   #7 normalize
class ProfileParamValidation extends LucidValidator<ProfileParamDto> {
  ProfileParamValidation(UserRepository repository) {
    // #5 include: reuse all e-mail rules (normalize/notEmpty/validEmail).
    include(ProfileEmailValidation());

    // #6 unless: the company name is validated UNLESS the account is individual
    // (i.e. only when `isCompany` is true).
    ruleFor((dto) => dto.companyName, key: 'companyName')
        .withName('Company name') // #1 withName overrides {PropertyName}
        .unless((dto) => !dto.isCompany)
        .notEmpty();

    // #3 ruleForEach: validate each tag inline, without a dedicated validator.
    ruleForEach((dto) => dto.tags, key: 'tags')
        .notEmpty()
        .withMessage('Tag cannot be empty')
        .maxLength(15);

    // #4 ruleSet + #2 mustAsync: the uniqueness check only runs on submit and
    // requires `validateAsync`.
    ruleSet(submitRuleSet, () {
      ruleFor((dto) => dto.email, key: 'email').mustAsync(
        (email) async => !await repository.emailTaken(email),
        'This e-mail is already registered',
        'EMAIL_TAKEN',
      );
    });
  }
}
