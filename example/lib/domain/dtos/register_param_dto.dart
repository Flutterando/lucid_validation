class RegisterParamDto {
  String email;
  String password;
  String phone;

  RegisterParamDto({
    required this.email,
    required this.password,
    required this.phone,
  });

  factory RegisterParamDto.empty() => RegisterParamDto(email: '', password: '', phone: '');

  setEmail(String value) => email = value;

  setPassword(String value) => password = value;

  setPhone(String value) => phone = value;
}
