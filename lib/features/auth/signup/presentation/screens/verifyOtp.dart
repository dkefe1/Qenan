import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signup/data/models/verifyOtp.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:qenan/features/auth/signup/presentation/screens/userInfo.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/l10n/l10n.dart';

class VerifyOtp extends StatefulWidget {
  final String phone;
  const VerifyOtp({super.key, required this.phone});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  bool otpEmpty = true;
  final otpFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  Timer? timer;
  int start = 59;
  String countdownText = "0:59";
  bool resendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        setState(() {});
      });
    }
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
  }

  void startTimer() {
    setState(() {
      resendButtonEnabled = false;
    });
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            resendButtonEnabled = true;
          });
        } else {
          setState(() {
            start--;
            countdownText = "0:${start.toString().padLeft(2, '0')}";
          });
        }
      },
    );
  }

  void resetTimer() {
    setState(() {
      timer?.cancel();
      start = 59;
      countdownText = "0:59";
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          print(state);
          if (state is OtpLoadingState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is OtpSuccessfulState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.accountCreated),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => UserInfo()));
          } else if (state is OtpFailureState) {
            setState(() {
              isLoading = false;
            });
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

    String phoneNumber = widget.phone;
    if (phoneNumber.startsWith('251')) {
      phoneNumber = '0' + phoneNumber.substring(3);
    }
    String shortPhoneNumber = phoneNumber.substring(0, 4);
    return Form(
      key: otpFormKey,
      child: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: height * 0.06, left: 42, right: 42),
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/otpBg.jpg"), fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: width < 390 ? 60 : 70,
                width: width < 390 ? 100 : 115,
                margin: EdgeInsets.only(top: height * 0.06, left: 40),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/qenanLogo.png"),
                        fit: BoxFit.cover)),
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
                    Text(
                      AppLocalizations.of(context)!.enterConfirmation,
                      style: TextStyle(
                          fontSize: width < 390 ? 25 : 30,
                          fontWeight: FontWeight.w900,
                          height: 0.8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.confirmationCode,
                          style: TextStyle(
                              fontSize: width < 390 ? 25 : 30,
                              fontWeight: FontWeight.w900,
                              height: 1),
                        ),
                        const Text(
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
                    Text(
                      "${AppLocalizations.of(context)!.fourDigitCode} \n ${shortPhoneNumber} ** ** ** ${AppLocalizations.of(context)!.sent}",
                      style: TextStyle(
                          color: grayTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: width < 390 ? 15 : 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: width < 390 ? 50 : 60,
                          height: width < 390 ? 45 : 55,
                          child: Container(
                            margin: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: _focusNodes[index].hasFocus
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF0C2566),
                                          Color(0xFF0094FF)
                                        ],
                                      )
                                    : null,
                                color: _focusNodes[index].hasFocus
                                    ? null
                                    : whiteColor),
                            child: TextField(
                              autofocus: true,
                              controller: otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              onChanged: (value) {
                                _onOtpChanged(index, value);
                              },
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                  counterText: '',
                                  focusColor: secondaryColor,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: secondaryColor)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: otpFieldColor)),
                                  fillColor: whiteColor,
                                  filled: true),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: resendButtonEnabled
                                ? () {
                                    resetTimer();
                                  }
                                : null,
                            child: Text(
                              AppLocalizations.of(context)!.resendCode,
                              style: TextStyle(
                                  color: resendButtonEnabled
                                      ? secondaryColor
                                      : grayTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            )),
                        Text(
                          countdownText,
                          style: TextStyle(
                              color: grayTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(),
                      ],
                    ),
                    SizedBox(
                      height: width < 390 ? 20 : 40,
                    ),
                    submitButton(
                        text: isLoading
                            ? "${AppLocalizations.of(context)!.verifyingOTP}..."
                            : AppLocalizations.of(context)!.continueBtn,
                        disable: otpEmpty || isLoading,
                        onInteraction: () {
                          if (otpFormKey.currentState!.validate()) {
                            bool anyEmpty = otpControllers
                                .any((controller) => controller.text.isEmpty);
                            setState(() {
                              otpEmpty = anyEmpty;
                            });
                            if (!otpEmpty) {
                              // Handle the filled OTP case
                              print('OTP is fully filled');
                            }
                            String otpCode = otpControllers
                                .map((controller) => controller.text)
                                .join();
                            final otpVerification =
                                BlocProvider.of<SignupBloc>(context);
                            otpVerification.add(PostRegistrationOTPEvent(
                                RegistrationOtp(
                                    phone: widget.phone, code: otpCode)));
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

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < otpControllers.length - 1) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }

    // Update the OTP controllers with the new value
    otpControllers[index].text = value;

    // Check if all OTP fields are filled
    bool allFilled =
        otpControllers.every((controller) => controller.text.isNotEmpty);
    setState(() {
      otpEmpty = !allFilled;
    });
  }
}
