import 'package:lucid_validation/lucid_validation.dart';
import 'package:test/test.dart';

import 'mocks/mocks.dart';

void main() {
  test('complex validations', () {

    final studentValidator = StudentValidator();
    final validator = TestLucidValidator<Classroom>();

    validator.ruleFor((c) => c.className, key: 'className').notEmpty();

    validator.ruleFor((c) => c.teacher, key: 'teacher')
      .setValidator(TeacherModelValidator());

    validator
        .ruleFor((c) => c.students, key: 'students')
        .setEach(studentValidator);

    final model = Classroom(
      teacher: TeacherModel()
        ..name = '',
      students: [
        // invalid
        StudentModel()
          ..email = 'teste@gmail.com'
          ..name = '',
        // invalid
        StudentModel()
          ..email = ''
          ..name = 'test',
        // valid
        StudentModel()
          ..email = 'teste@gmail.com'
          ..name = 'test',
      ],
    );

    final result = validator.validate(model);
    final exceptions = result.exceptions;

    expect(exceptions[0].key, "className");
    expect(exceptions[0].entity, "Classroom");

    expect(exceptions[1].key, "name");
    expect(exceptions[1].entity, "TeacherModel");

    expect(exceptions[2].key, "name");
    expect(exceptions[2].entity, "StudentModel");
    expect(exceptions[2].index, 0);

    expect(exceptions[3].key, "email");
    expect(exceptions[3].entity, "StudentModel");
    expect(exceptions[3].index, 1);

    expect(exceptions.length, 4);
  });
}
