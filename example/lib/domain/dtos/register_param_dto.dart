class RegisterParamDto {
  String email;
  String phone;
  String password;
  String confirmPassword;

  RegisterParamDto({
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterParamDto.empty() => RegisterParamDto(email: '', password: '', phone: '', confirmPassword: '');

  setEmail(String value) => email = value;

  setPassword(String value) => password = value;

  setConfirmPassword(String value) => confirmPassword = value;

  setPhone(String value) => phone = value;
}
