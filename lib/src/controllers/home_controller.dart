import 'package:bookstore_app_web/src/models/book.dart';
import 'package:bookstore_app_web/src/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

class HomeController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  String? role;

  HomeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    super.initState();
  }

  getRoleOfUser() {
    userRepo.getCurrentUser().then((User? user) {
      setState(() {
        role = user!.role;
        print('role: $role');
      });
    });


  }

  logout() async {
    userRepo.logout().then((value) {
      Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
          '/Login', (Route<dynamic> route) => false);
        });
  }

  Future<ResponseBooks> fetchBooks(limit,offset, query) async {
    return getBooks(limit, offset, query);
  }

  Future<String> deleteBook(int id) async {
    return deleteBookRepo(id);
  }

  Future<String> updateBook(Book book) async {
    return updateBookRepo(book);
  }
}

