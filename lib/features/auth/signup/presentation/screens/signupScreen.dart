import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:qenan/features/auth/signup/data/models/signup.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:qenan/features/auth/signup/presentation/screens/verifyOtp.dart';
import 'package:qenan/features/auth/signup/presentation/widgets/transformPhoneNumber.dart';
import 'package:qenan/features/common/emailFormField.dart';
import 'package:qenan/features/common/emailValidator.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/passwordFormField.dart';
import 'package:qenan/features/common/phoneFormField.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/features/common/textformfield.dart';
import 'package:qenan/features/guidelines/presentation/screens/privacyPolicyScreen.dart';
import 'package:qenan/features/guidelines/presentation/screens/termsScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final prefs = PrefService();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  bool isUserNameEmpty = false;
  bool isEmailEmpty = false;
  bool isPhoneEmpty = false;
  bool isPwdEmpty = false;
  bool isConfirmPwdEmpty = false;
  bool isPwdDifferent = false;
  bool isPwdInvalid = false;
  bool isEmailInvalid = false;
  bool isPhoneInvalid = false;
  bool isChecked = false;
  bool isTermsNotChecked = false;
  final signupFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pwdController.dispose();
    confirmPwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          print(state);
          if (state is SignupLoadingState) {
            isLoading = true;
          } else if (state is SignupSuccessfulState) {
            isLoading = false;
            prefs.login(pwdController.text);

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => VerifyOtp(
                    phone: transformPhoneNumber(phoneController.text))));
          } else if (state is SignupFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Form(
        key: signupFormKey,
        child: Container(
          padding: const EdgeInsets.only(
            left: 23,
            right: 23,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/registerBg.jpg"),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Image.asset(
                  "images/qenanLogo.png",
                  width: 107,
                  height: 64,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 23, horizontal: 19),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(32)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.signup,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            ".",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Text(
                        AppLocalizations.of(context)!.createAnAccount,
                        style: TextStyle(
                            color: grayTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      textFormField(
                          controller: firstNameController,
                          hintText: AppLocalizations.of(context)!.firstName,
                          onInteraction: () {
                            setState(() {
                              isFirstNameEmpty = false;
                            });
                          }),
                      isFirstNameEmpty
                          ? errorText(
                              text:
                                  AppLocalizations.of(context)!.emptyFirstName)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 12,
                      ),
                      textFormField(
                          controller: lastNameController,
                          hintText: AppLocalizations.of(context)!.lastName,
                          onInteraction: () {
                            setState(() {
                              isLastNameEmpty = false;
                            });
                          }),
                      isLastNameEmpty
                          ? errorText(
                              text: AppLocalizations.of(context)!.emptyLastName)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 50,
                      ),
                      textFormField(
                          controller: userNameController,
                          hintText: AppLocalizations.of(context)!.userName,
                          onInteraction: () {
                            setState(() {
                              isUserNameEmpty = false;
                            });
                          }),
                      isUserNameEmpty
                          ? errorText(
                              text: AppLocalizations.of(context)!.emptyUserName)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 12,
                      ),
                      emailFormField(
                          controller: emailController,
                          hintText: AppLocalizations.of(context)!.email,
                          onInteraction: () {
                            setState(() {
                              isEmailEmpty = false;
                              isEmailInvalid = false;
                            });
                          }),
                      isEmailEmpty
                          ? errorText(
                              text: AppLocalizations.of(context)!.emptyEmail)
                          : SizedBox.shrink(),
                      isEmailInvalid
                          ? errorText(
                              text: AppLocalizations.of(context)!.invalidEmail)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 12,
                      ),
                      phoneFormField(
                          controller: phoneController,
                          hintText: "09 *** ** ***",
                          onInteraction: () {
                            setState(() {
                              isPhoneEmpty = false;
                              isPhoneInvalid = false;
                            });
                          }),
                      isPhoneEmpty
                          ? errorText(
                              text: AppLocalizations.of(context)!.emptyPhone)
                          : SizedBox.shrink(),
                      isPhoneInvalid
                          ? errorText(
                              text: AppLocalizations.of(context)!.invalidPhone)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 50,
                      ),
                      passwordFormField(
                          controller: pwdController,
                          labelText:
                              AppLocalizations.of(context)!.createPassword,
                          onInteraction: () {
                            setState(() {
                              isPwdEmpty = false;
                              isPwdDifferent = false;
                              isPwdInvalid = false;
                            });
                          }),
                      isPwdEmpty
                          ? errorText(
                              text: AppLocalizations.of(context)!.emptyPassword)
                          : SizedBox.shrink(),
                      isPwdDifferent
                          ? errorText(
                              text:
                                  AppLocalizations.of(context)!.invalidPassword)
                          : SizedBox.shrink(),
                      isPwdInvalid
                          ? errorText(
                              text: AppLocalizations.of(context)!.shortPassword)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 12,
                      ),
                      passwordFormField(
                          controller: confirmPwdController,
                          labelText:
                              AppLocalizations.of(context)!.confirmPassword,
                          onInteraction: () {
                            setState(() {
                              isConfirmPwdEmpty = false;
                              isPwdDifferent = false;
                            });
                          }),
                      isConfirmPwdEmpty
                          ? errorText(
                              text: AppLocalizations.of(context)!.emptyConfirm)
                          : SizedBox.shrink(),
                      isPwdDifferent
                          ? errorText(
                              text:
                                  AppLocalizations.of(context)!.invalidPassword)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              checkColor: whiteColor,
                              activeColor: primaryColor,
                              value: isChecked,
                              side: const BorderSide(color: primaryColor),
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  isTermsNotChecked = false;
                                });
                              }),
                          Expanded(
                            child: Text.rich(
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                TextSpan(
                                    style: const TextStyle(fontSize: 12),
                                    children: [
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .agreeTo,
                                          style: TextStyle(
                                              color: grayTextColor,
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .termsAndConditions,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TermsAndConditionScreen()));
                                            },
                                          style: const TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .andThe,
                                          style: TextStyle(
                                              color: grayTextColor,
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .privacyPolicy,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrivacyPolicyScreen()));
                                            },
                                          style: const TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .agreed,
                                          style: TextStyle(
                                              color: grayTextColor,
                                              fontWeight: FontWeight.w400)),
                                    ])),
                          )
                        ],
                      ),
                      isTermsNotChecked
                          ? errorText(
                              text: AppLocalizations.of(context)!.termNotAgreed)
                          : SizedBox.shrink(),
                      const SizedBox(
                        height: 26,
                      ),
                      submitButton(
                          text: isLoading
                              ? "${AppLocalizations.of(context)!.registeringYou}..."
                              : AppLocalizations.of(context)!.register,
                          disable: isLoading,
                          onInteraction: () {
                            if (signupFormKey.currentState!.validate()) {
                              if (firstNameController.text.isEmpty) {
                                return setState(() {
                                  isFirstNameEmpty = true;
                                });
                              }
                              if (lastNameController.text.isEmpty) {
                                return setState(() {
                                  isLastNameEmpty = true;
                                });
                              }
                              if (userNameController.text.isEmpty) {
                                return setState(() {
                                  isUserNameEmpty = true;
                                });
                              }
                              if (emailController.text.isEmpty) {
                                return setState(() {
                                  isEmailEmpty = true;
                                });
                              }
                              if (phoneController.text.isEmpty) {
                                return setState(() {
                                  isPhoneEmpty = true;
                                });
                              }
                              if (pwdController.text.isEmpty) {
                                return setState(() {
                                  isPwdEmpty = true;
                                });
                              }
                              if (confirmPwdController.text.isEmpty) {
                                return setState(() {
                                  isConfirmPwdEmpty = true;
                                });
                              }
                              if (pwdController.text.length < 8) {
                                return setState(() {
                                  isPwdInvalid = true;
                                });
                              }
                              if (emailController.text.isNotEmpty) {
                                if (!isEmailValid(emailController.text)) {
                                  return setState(() {
                                    isEmailInvalid = true;
                                  });
                                }
                              }
                              if (!RegExp(r'^(09|07)[0-9]{8}$')
                                  .hasMatch(phoneController.text)) {
                                return setState(() {
                                  isPhoneInvalid = true;
                                });
                              }
                              if (pwdController.text !=
                                  confirmPwdController.text) {
                                return setState(() {
                                  isPwdDifferent = true;
                                });
                              }
                              setState(() {
                                isTermsNotChecked = !isChecked;
                              });
                              if (!isChecked) {
                                return;
                              }

                              print("first_name:" + firstNameController.text);
                              print("last_name:" + lastNameController.text);
                              print("user_name:" + userNameController.text);
                              print("Email:" + emailController.text);
                              print("Phone:"
                                  "${transformPhoneNumber(phoneController.text)}");
                              print("password:" + pwdController.text);
                              print("Confirm password:" +
                                  confirmPwdController.text);

                              print("YAYYYYY!!");
                              final signup =
                                  BlocProvider.of<SignupBloc>(context);
                              signup.add(PostSignupEvent(Signup(
                                  first_name: firstNameController.text,
                                  last_name: lastNameController.text,
                                  username: userNameController.text,
                                  email: emailController.text,
                                  phone: transformPhoneNumber(
                                      phoneController.text),
                                  password: pwdController.text,
                                  password_confirmation:
                                      confirmPwdController.text)));
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(style: TextStyle(fontSize: 12), children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .alreadyHaveAccount,
                                  style: TextStyle(
                                      color: grayTextColor,
                                      fontWeight: FontWeight.w400)),
                              TextSpan(
                                  text: AppLocalizations.of(context)!.signin,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SigninScreen()));
                                    },
                                  style: const TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ])),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}
