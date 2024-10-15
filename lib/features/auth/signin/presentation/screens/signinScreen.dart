import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signin/data/models/signin.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:qenan/features/auth/signin/presentation/screens/forgotPasswordScreen.dart';
import 'package:qenan/features/auth/signup/presentation/screens/signupScreen.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/languageDropdown.dart';
import 'package:qenan/features/common/passwordFormField.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/features/common/textformfield.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/indexScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final prefs = PrefService();
  TextEditingController userNamePhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isUserNameEmpty = false;
  bool isPwdEmpty = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    userNamePhoneController.dispose();
    passwordController.dispose();
  }

  final signinFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          print(state);
          if (state is SigninLoadingState) {
            isLoading = true;
          } else if (state is SigninSuccessfulState) {
            isLoading = false;
            prefs.login(passwordController.text);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const IndexScreen(
                      pageIndex: 0,
                    )));
          } else if (state is SigninFailureState) {
            isLoading = false;
            print(state.error);
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
      key: signinFormKey,
      child: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/loginBg.jpg"), fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: dropdownWidget(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: width < 390 ? 105 : 125,
                    width: width < 390 ? 190 : 213,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/qenanLogo.png"))),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(23, 0, 23, 25),
                    padding: EdgeInsets.only(
                        top: width < 390 ? 25 : 35,
                        bottom: 20,
                        right: 19,
                        left: 19),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: whiteColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcome,
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900),
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
                        SizedBox(
                          height: width < 390 ? 15 : 25,
                        ),
                        textFormField(
                            controller: userNamePhoneController,
                            hintText: AppLocalizations.of(context)!
                                .userNameOrPhoneNumber,
                            onInteraction: () {
                              setState(() {
                                isUserNameEmpty = false;
                              });
                            }),
                        isUserNameEmpty
                            ? errorText(
                                text: AppLocalizations.of(context)!
                                    .emptyUserNamePassword)
                            : SizedBox.shrink(),
                        const SizedBox(
                          height: 14,
                        ),
                        passwordFormField(
                            controller: passwordController,
                            labelText: AppLocalizations.of(context)!.password,
                            onInteraction: () {
                              setState(() {
                                isPwdEmpty = false;
                              });
                            }),
                        isPwdEmpty
                            ? errorText(
                                text:
                                    AppLocalizations.of(context)!.yourPassword)
                            : SizedBox.shrink(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: width < 390 ? 15 : 26,
                        ),
                        submitButton(
                            text: isLoading
                                ? "${AppLocalizations.of(context)!.loggingIn}..."
                                : AppLocalizations.of(context)!.login,
                            disable: isLoading,
                            onInteraction: () {
                              if (signinFormKey.currentState!.validate()) {
                                if (userNamePhoneController.text.isEmpty) {
                                  return setState(() {
                                    isUserNameEmpty = true;
                                  });
                                }
                                if (passwordController.text.isEmpty) {
                                  return setState(() {
                                    isPwdEmpty = true;
                                  });
                                }

                                final signin =
                                    BlocProvider.of<SigninBloc>(context);
                                signin.add(PostSigninEvent(Signin(
                                    identifier: userNamePhoneController.text,
                                    password: passwordController.text)));
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                  style: TextStyle(fontSize: 12),
                                  children: [
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .notAMember,
                                        style: TextStyle(
                                            color: grayTextColor,
                                            fontWeight: FontWeight.w400)),
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .registerNow,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignupScreen()));
                                          },
                                        style: const TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w600)),
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
