import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:qenan/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/features/home/presentation/widgets/logoutButton.dart';
import 'package:qenan/l10n/l10n.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  final prefs = PrefService();
  bool isLoading = false;
  bool isLoggingOut = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            actionsAlignment: MainAxisAlignment.end,
            backgroundColor: whiteColor,
            surfaceTintColor: whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            content: Container(
              height: 150,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.logOut,
                    style: TextStyle(
                        color: darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    AppLocalizations.of(context)!.areYouSureYouWantToLogOut,
                    style: TextStyle(
                        color: darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.31,
                        child: submitButton(
                          text: AppLocalizations.of(context)!.cancel,
                          disable: false,
                          onInteraction: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.31,
                        child: logoutButton(
                            text: isLoading
                                ? "${AppLocalizations.of(context)!.signingOut}.."
                                : AppLocalizations.of(context)!.signOut,
                            disable: isLoading,
                            onInteraction: () async {
                              print(await prefs.readToken());
                              if (!isLoggingOut) {
                                setState(() {
                                  isLoggingOut = true;
                                  isLoading = true;
                                });
                                BlocProvider.of<LogoutBloc>(context)
                                    .add(DelLogoutEvent());
                              }
                            }),
                      ),
                    ],
                  ),
                  BlocConsumer<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      print(state);
                      if (state is LogoutLoadingState) {
                        setState(() {
                          isLoading = true;
                        });
                        Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      } else if (state is LogoutSuccessfulState) {
                        setState(() {
                          isLoading = false;
                          isLoggingOut = false;
                        });

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SigninScreen()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .loggedOutSuccessfully),
                            backgroundColor: Colors.green,
                          ),
                        );
                        prefs.removeToken();
                        prefs.logout();
                      } else if (state is LogoutFailureState) {
                        setState(() {
                          Navigator.of(context).pop();
                          isLoading = false;
                          isLoggingOut = false;
                        });
                        Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Container();
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
