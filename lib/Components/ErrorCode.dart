import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ActionStatus { Done, Waiting, Start, Error }
enum ClientSignUpError {
  EmailInvalid,
  PasswordTooWeak,
  PasswordTooLong,
  PasswordTrim,
  RePasswordWrong,
  TermsOfServicesUnCheck,
}

enum ServerSignUpError {
  EmailRegistered,
  UnknownError,
  InternetException,
  ServerMaintenance,
}

extension ClientSignUpErrorCode on ClientSignUpError {
  int get errorCode {
    switch (this) {
      case ClientSignUpError.EmailInvalid:
        return 1;
      case ClientSignUpError.PasswordTooWeak:
        return 2;
      case ClientSignUpError.PasswordTooLong:
        return 3;
      case ClientSignUpError.PasswordTrim:
        return 4;
      case ClientSignUpError.RePasswordWrong:
        return 5;
      case ClientSignUpError.TermsOfServicesUnCheck:
        return 6;
    }
  }

  String errorMessage(BuildContext context) {
    switch (this) {
      case ClientSignUpError.EmailInvalid:
        return AppLocalizations.of(context)!.emailInvalid;
      case ClientSignUpError.PasswordTooWeak:
        return AppLocalizations.of(context)!.passwordTooWeak;
      case ClientSignUpError.PasswordTooLong:
        return AppLocalizations.of(context)!.passwordTooLong;
      case ClientSignUpError.PasswordTrim:
        return AppLocalizations.of(context)!.passwordTrim;
      case ClientSignUpError.RePasswordWrong:
        return AppLocalizations.of(context)!.rePasswordWrong;
      case ClientSignUpError.TermsOfServicesUnCheck:
        return AppLocalizations.of(context)!.termsOfServicesUncheck;
    }
  }
}

extension ServerSignUpErrorCode on ServerSignUpError {
  int get errorCode {
    switch (this) {
      case ServerSignUpError.EmailRegistered:
        return 1;
      case ServerSignUpError.UnknownError:
        return 2;
      case ServerSignUpError.InternetException:
        return 3;
      case ServerSignUpError.ServerMaintenance:
        return 4;
    }
  }

  String errorMessage(BuildContext context) {
    switch (this) {
      case ServerSignUpError.EmailRegistered:
        return AppLocalizations.of(context)!.emailRegistered;
      case ServerSignUpError.UnknownError:
        return AppLocalizations.of(context)!.unknownError;
      case ServerSignUpError.InternetException:
        return AppLocalizations.of(context)!.internetException;
      case ServerSignUpError.ServerMaintenance:
        return AppLocalizations.of(context)!.serverMaintenance;
    }
  }
}
