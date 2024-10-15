String transformPhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith('0')) {
    return '251' + phoneNumber.substring(1);
  } else {
    return phoneNumber;
  }
}
