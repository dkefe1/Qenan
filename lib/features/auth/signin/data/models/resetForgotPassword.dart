class ResetForgotPassword {
  final String phone;
  final String password;
  final String password_confirmation;

  ResetForgotPassword(
      {required this.phone,
      required this.password,
      required this.password_confirmation});
}
