class LoginParamDto {
  String email;
  String password;

  LoginParamDto({
    required this.email,
    required this.password,
  });

  factory LoginParamDto.empty() => LoginParamDto(email: '', password: '');

  setEmail(String value) => email = value;

  setPassword(String value) => email = value;
}
