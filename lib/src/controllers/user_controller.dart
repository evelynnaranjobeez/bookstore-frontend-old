import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart'
    as repository;
import '../../main.dart';
import '../models/user.dart';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool isLoading = false;
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<ScaffoldState> scaffoldKey;


  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      loginFormKey.currentState!.save();
      repository.login(user).then((value) {
        //print(value.apiToken);
        if (value.apiToken != null) {
          // scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(S.current.welcome + value.name),
          // ));
          setState(() {
            isLoading = false;
          });
          Navigator.of(scaffoldKey.currentContext!)
              .pushReplacementNamed('/Homepage');
        } else {
          setState(() {
            isLoading = false;
          });
          // scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(S.current.wrong_email_or_password),
          // ));
        }
      });
    }
  }



  void register() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      repository.register(user).then((value) {
        if (value.apiToken != null) {
          // scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(S.current.welcome + value.name),
          // ));
          Navigator.of(scaffoldKey.currentContext!)
              .pushReplacementNamed('/Pages', arguments: 1);
        } else {
          // scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(S.current.wrong_email_or_password),
          // ));
        }
      });
    }
  }
}
