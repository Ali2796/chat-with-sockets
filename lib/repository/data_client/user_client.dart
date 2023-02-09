import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_chat_flutter/repository/api_urls.dart';
import 'package:socket_io_chat_flutter/repository/data_model/user_friends_model.dart';
import 'package:socket_io_chat_flutter/repository/data_model/user_response_model.dart';
import 'package:socket_io_chat_flutter/screens/utils/show_toast.dart';

import '../data_model/user_login_model.dart';

class UserClient extends ChangeNotifier {
  UserResponseModel? _userModel;
  UserFriendsModel? _userFriendsModel;
  String? _token;

  String? get token => _token;

  UserFriendsModel? get userFriendsModel => _userFriendsModel;

  UserResponseModel? get userModel => _userModel;

  Future<UserResponseModel?> postUserAuth({
    required UserLoginModel userLoginModel,
  }) async {
    print('object///////////////postuserauth');
    try {
      http.Response response = await http.post(
          Uri.parse(ApiUrls.baseUrl + ApiUrls.userToken),
          body: jsonEncode(userLoginModel.toJson()),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          });
      print('//////////${response.statusCode},,/////////${response.body}');
      if (response.statusCode == 200) {
        var mapData = jsonDecode(response.body);
        _userModel = UserResponseModel.fromJson(mapData);
        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: _userModel?.token);
        print('..........Token:${_userModel?.token}');

        _token = await storage.read(key: "token");
      }
    } on TimeoutException catch (timeout) {
      CustomToast.showToast(msg: timeout.message.toString(), isError: true);
    } on HttpException catch (httpError) {
      CustomToast.showToast(msg: httpError.message.toString(), isError: true);
    } catch (error) {
      CustomToast.showToast(msg: error.toString(), isError: true);
    }
    notifyListeners();
    return _userModel;
  }

  Future<List<UserFriendsModel>?> getFriends() async {
    const storage = FlutterSecureStorage();
    List<UserFriendsModel> friendsResponse = [];
    String? token = await storage.read(key: "token");
    http.Response response =
        await http.get(Uri.parse('${ApiUrls.baseUrl}friends'), headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'token ${token!}'
    });
    if (response.statusCode == 200) {
      var mapData = jsonDecode(response.body);

      mapData.map<UserFriendsModel>((e) {
        friendsResponse.add(UserFriendsModel.fromJson(e));
        return UserFriendsModel.fromJson(e);
      }).toList();

      print('..................firstName..........${friendsResponse.length}');
    }
    notifyListeners();
    return friendsResponse;
  }

  Future<void> chatInit() async {
    const storage = FlutterSecureStorage();

    String? token = await storage.read(key: "token");
    notifyListeners();
  }
}
