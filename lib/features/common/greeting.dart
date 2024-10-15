import 'package:flutter/material.dart';
import 'package:qenan/l10n/l10n.dart';

String getGreetingMessage(BuildContext context) {
  final int hour = DateTime.now().hour;

  if (hour < 12) {
    return AppLocalizations.of(context)!.goodMorning;
  } else if (hour < 18) {
    return AppLocalizations.of(context)!.goodAfternoon;
  } else {
    return AppLocalizations.of(context)!.goodEvening;
  }
}
