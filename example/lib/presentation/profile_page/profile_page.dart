import 'package:example/domain/dtos/profile_param_dto.dart';
import 'package:example/domain/repositories/user_repository.dart';
import 'package:example/domain/validations/profile_param_validation.dart';
import 'package:flutter/material.dart';

/// Showcase page for the 1.4.0 features following the project architecture
/// (domain + presentation).
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final repository = UserRepository();
  late final validator = ProfileParamValidation(repository);
  final dto = ProfileParamDto.empty();
  final formKey = GlobalKey<FormState>();

  bool _submitting = false;

  /// Validation messages for the tag list, keyed by item index (filled on submit
  /// from `ruleForEach` results).
  Map<int, String> _tagErrors = {};

  SnackBar _snackBar(String message, Color color) => SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(message),
      );

  Future<void> _submit() async {
    // Live (synchronous) field validation first.
    formKey.currentState?.validate();

    setState(() => _submitting = true);

    // #4 + #2 run every rule, including the async uniqueness check in the
    // 'submit' rule set.
    final result = await validator.validateAsync(dto, ruleSets: ['*']);

    if (!mounted) return;

    setState(() {
      _submitting = false;
      _tagErrors = {
        for (final e in result.exceptions)
          if (e.key == 'tags' && e.index != null) e.index!: e.message,
      };
    });

    final messenger = ScaffoldMessenger.of(context);
    if (result.isValid) {
      messenger.showSnackBar(_snackBar('Profile saved!', Colors.green));
    } else {
      messenger.showSnackBar(
        _snackBar(result.exceptions.first.message, Colors.red.shade400),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company profile')),
      body: Form(
        key: formKey,
        child: ListenableBuilder(
          listenable: dto,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Demonstrates: normalize, withMessage/withErrorCode/withName, '
                  'include, unless, ruleForEach, ruleSet and async validation.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // #7 normalize + #1 withMessage/withErrorCode (via include).
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: dto.setEmail,
                  validator: validator.byField(dto, 'email'),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: '  USER@EMAIL.COM  (trimmed + lowercased)',
                  ),
                ),
                const SizedBox(height: 12),

                // Toggles the #6 unless condition for the company name.
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Company account'),
                  subtitle: const Text(
                      'Company name is required only when this is on (unless)'),
                  value: dto.isCompany,
                  onChanged: (value) {
                    dto.setIsCompany(value);
                    formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 12),

                // #6 unless: validated only for company accounts.
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: dto.setCompanyName,
                  validator: validator.byField(dto, 'companyName'),
                  decoration: const InputDecoration(labelText: 'Company name'),
                ),
                const SizedBox(height: 24),

                // #3 ruleForEach: a dynamic list of tags.
                Row(
                  children: [
                    const Text('Tags', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      onPressed: dto.addTag,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                for (var i = 0; i < dto.tags.length; i++)
                  Padding(
                    key: ValueKey('tag_$i'),
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: dto.tags[i],
                            onChanged: (value) => dto.setTag(i, value),
                            decoration: InputDecoration(
                              labelText: 'Tag ${i + 1}',
                              errorText: _tagErrors[i],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              dto.tags.length > 1 ? () => dto.removeTag(i) : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save (checks e-mail availability)'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
