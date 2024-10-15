import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signin/data/models/forgotPassword.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:qenan/features/auth/signin/presentation/screens/otpScreen.dart';
import 'package:qenan/features/auth/signup/presentation/widgets/transformPhoneNumber.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/phoneFormField.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/l10n/l10n.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();

  final forgotPwdFormKey = GlobalKey<FormState>();

  bool isPhoneEmpty = false;
  bool isPhoneInvalid = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.08,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25, top: 6),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              )),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          print(state);
          if (state is ForgotPasswordLoadingState) {
            isLoading = true;
          } else if (state is ForgotPasswordSuccessfulState) {
            isLoading = false;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OtpScreen(
                    phone: transformPhoneNumber(phoneController.text))));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.otpSent),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ForgotPasswordFailureState) {
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
      key: forgotPwdFormKey,
      child: SingleChildScrollView(
        child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.forgotPasswordTitle,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: width < 390 ? 20 : 22,
                              fontWeight: FontWeight.w900,
                              height: 1),
                        ),
                        Text(
                          ".",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: width < 390 ? 20 : 22,
                              fontWeight: FontWeight.w900,
                              height: 1),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    phoneFormField(
                        controller: phoneController,
                        hintText: AppLocalizations.of(context)!.enterYourNumber,
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
                    SizedBox(
                      height: width < 390 ? 20 : 40,
                    ),
                    submitButton(
                        text: isLoading
                            ? "${AppLocalizations.of(context)!.loading}..."
                            : AppLocalizations.of(context)!.forgotPasswordTitle,
                        disable: isLoading,
                        onInteraction: () {
                          if (forgotPwdFormKey.currentState!.validate()) {
                            if (phoneController.text.isEmpty) {
                              return setState(() {
                                isPhoneEmpty = true;
                              });
                            }
                            if (!RegExp(r'^09[0-9]{8}$')
                                .hasMatch(phoneController.text)) {
                              return setState(() {
                                isPhoneInvalid = true;
                              });
                            }
                            final signin = BlocProvider.of<SigninBloc>(context);
                            signin.add(PostForgotPasswordEvent(ForgotPassword(
                                phone: transformPhoneNumber(
                                    phoneController.text))));
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
