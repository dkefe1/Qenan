import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signin/data/models/changePassword.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/passwordFormField.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/l10n/l10n.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmNewPwdController = TextEditingController();

  final changePwdFormKey = GlobalKey<FormState>();

  bool isCurrentPwdEmpty = false;
  bool isNewPwdEmpty = false;
  bool isConfirmNewPwdEmpty = false;
  bool isPwdDifferent = false;
  bool isPwdInvalid = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor:
            Colors.transparent, // Use glass instead of transparent
        toolbarHeight: height * 0.08,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25, top: 6),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: blackColor,
              )),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          print(state);
          if (state is ChangePasswordLoadingState) {
            isLoading = true;
            Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is ChangePasswordSuccessfulState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.pwdChangedSuccessfully),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ChangePasswordFailureState) {
            isLoading = false;
            Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
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
      key: changePwdFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 25),
              color: headerBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.12,
                  ),
                  Image.asset(
                    "images/blackLogo.png",
                    fit: BoxFit.fill,
                    width: width < 390 ? 85 : 100,
                    height: width < 390 ? 30 : 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.change,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: width < 390 ? 44 : 48,
                            fontWeight: FontWeight.w900,
                            height: 1),
                      ),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.chgPassword,
                            style: TextStyle(
                                color: blackColor,
                                fontSize: width < 390 ? 44 : 48,
                                fontWeight: FontWeight.w900,
                                height: 1),
                          ),
                          Text(
                            ".",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: width < 390 ? 44 : 48,
                                fontWeight: FontWeight.w900,
                                height: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  passwordFormField(
                      controller: currentPwdController,
                      labelText: AppLocalizations.of(context)!.currentPassword,
                      onInteraction: () {
                        setState(() {
                          isCurrentPwdEmpty = false;
                        });
                      }),
                  isCurrentPwdEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.emptyCurrentPwd)
                      : SizedBox.shrink(),
                  const SizedBox(
                    height: 14,
                  ),
                  passwordFormField(
                      controller: newPwdController,
                      labelText: AppLocalizations.of(context)!.newPassword,
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
                      labelText: AppLocalizations.of(context)!.confirmPassword,
                      onInteraction: () {
                        setState(() {
                          isConfirmNewPwdEmpty = false;
                          isPwdDifferent = false;
                        });
                      }),
                  isConfirmNewPwdEmpty
                      ? errorText(
                          text:
                              AppLocalizations.of(context)!.emptyConfirmNewPwd)
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
                          ? "${AppLocalizations.of(context)!.loading}..."
                          : AppLocalizations.of(context)!.continueBtn,
                      disable: isLoading,
                      onInteraction: () {
                        if (changePwdFormKey.currentState!.validate()) {
                          if (currentPwdController.text.isEmpty) {
                            return setState(() {
                              isCurrentPwdEmpty = true;
                            });
                          }
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
                          final changePwd =
                              BlocProvider.of<ChangePasswordBloc>(context);

                          changePwd.add(PostChangePasswordEvent(ChangePassword(
                              password: currentPwdController.text,
                              new_password: newPwdController.text,
                              new_password_confirmation:
                                  confirmNewPwdController.text)));
                        }
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
