import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signin/data/models/resetForgotPassword.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:qenan/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/passwordFormField.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/l10n/l10n.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  const ResetPasswordScreen({super.key, required this.phone});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmNewPwdController = TextEditingController();

  final resetPwdFormKey = GlobalKey<FormState>();

  bool isNewPwdEmpty = false;
  bool isConfirmNewPwdEmpty = false;
  bool isPwdDifferent = false;
  bool isPwdInvalid = false;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    newPwdController.dispose();
    confirmNewPwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          print(state);
          if (state is ResetForgotPasswordLoadingState) {
            isLoading = true;
          } else if (state is ResetForgotPasswordSuccessfulState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.resetSuccessful),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SigninScreen()));
          } else if (state is ResetForgotPasswordFailureState) {
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
      key: resetPwdFormKey,
      child: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: height * 0.06, left: 42, right: 42),
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/loginBg.jpg"), fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                height: width < 390 ? 105 : 125,
                width: width < 390 ? 190 : 213,
                margin: EdgeInsets.only(top: height * 0.15),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/qenanLogo.png"))),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(23, 0, 23, 30),
                padding: EdgeInsets.only(
                    top: width < 390 ? 25 : 35,
                    bottom: 20,
                    right: 19,
                    left: 19),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(32)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.resetPassword,
                          style: TextStyle(
                              fontSize: width < 390 ? 28 : 30,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ".",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    passwordFormField(
                        controller: newPwdController,
                        labelText: AppLocalizations.of(context)!.createPassword,
                        onInteraction: () {
                          setState(() {
                            isNewPwdEmpty = false;
                            isPwdDifferent = false;
                            isPwdInvalid = false;
                          });
                        }),
                    isNewPwdEmpty
                        ? errorText(
                            text: AppLocalizations.of(context)!.emptyNewPwd)
                        : SizedBox.shrink(),
                    isPwdDifferent
                        ? errorText(
                            text: AppLocalizations.of(context)!.invalidPassword)
                        : SizedBox.shrink(),
                    isPwdInvalid
                        ? errorText(
                            text: AppLocalizations.of(context)!.shortPassword)
                        : SizedBox.shrink(),
                    const SizedBox(
                      height: 14,
                    ),
                    passwordFormField(
                        controller: confirmNewPwdController,
                        labelText:
                            AppLocalizations.of(context)!.confirmPassword,
                        onInteraction: () {
                          setState(() {
                            isConfirmNewPwdEmpty = false;
                            isPwdDifferent = false;
                          });
                        }),
                    isConfirmNewPwdEmpty
                        ? errorText(
                            text: AppLocalizations.of(context)!.emptyConfirm)
                        : SizedBox.shrink(),
                    isPwdDifferent
                        ? errorText(
                            text: AppLocalizations.of(context)!.invalidPassword)
                        : SizedBox.shrink(),
                    SizedBox(
                      height: width < 390 ? 20 : 40,
                    ),
                    submitButton(
                        text: isLoading
                            ? AppLocalizations.of(context)!.loading
                            : AppLocalizations.of(context)!.continueBtn,
                        disable: isNewPwdEmpty && isConfirmNewPwdEmpty,
                        onInteraction: () {
                          if (resetPwdFormKey.currentState!.validate()) {
                            if (newPwdController.text.isEmpty) {
                              return setState(() {
                                isNewPwdEmpty = true;
                              });
                            }
                            if (confirmNewPwdController.text.isEmpty) {
                              return setState(() {
                                isConfirmNewPwdEmpty = true;
                              });
                            }
                            if (newPwdController.text.length < 8) {
                              return setState(() {
                                isPwdInvalid = true;
                              });
                            }
                            if (newPwdController.text !=
                                confirmNewPwdController.text) {
                              return setState(() {
                                isPwdDifferent = true;
                              });
                            }

                            final changePassword =
                                BlocProvider.of<SigninBloc>(context);
                            changePassword.add(PostResetForgotPasswordEvent(
                                ResetForgotPassword(
                                    phone: widget.phone,
                                    password: newPwdController.text,
                                    password_confirmation:
                                        confirmNewPwdController.text)));
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
