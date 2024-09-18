import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../repository/user_repository.dart' as userRepo;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

User currentUser = new User();

Future<User> login(User user) async {

  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}login';
 final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    print(response.body);
    setCurrentUser(response.body);
    currentUser = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser;
}

Future<User> register(User user) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser;
}

Future<void> logout() async {
  currentUser = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['data'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'current_user', json.encode(json.decode(jsonString)['data']));
  }
}



Future<User?> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('current_user')) {
    currentUser =
        User.fromJSON(json.decode(prefs.get('current_user').toString()));
  }
  return currentUser;
}



Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}users/${currentUser.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser = User.fromJSON(json.decode(response.body)['data']);
  return currentUser;
}

