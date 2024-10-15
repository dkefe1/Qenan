bool isEmailValid(String email) {
  final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  return emailRegExp.hasMatch(email);
}
