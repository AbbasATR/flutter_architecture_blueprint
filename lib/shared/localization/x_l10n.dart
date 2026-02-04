import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/l10n/app_localizations.dart';

extension XLocalizations on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
