import 'dart:io';

import 'package:cuidaper_mobile/app/core/exceptions/failure.dart';
import 'package:cuidaper_mobile/app/core/exceptions/user_exists_exception.dart';
import 'package:cuidaper_mobile/app/core/exceptions/user_notfound_exception.dart';
import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/core/push_notification/push_notification.dart';
import 'package:cuidaper_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidaper_mobile/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidaper_mobile/app/models/confirm_login_model.dart';
import 'package:cuidaper_mobile/app/models/social_network_model.dart';
import 'package:cuidaper_mobile/app/models/user_model.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final Logger _log;

  UserRepositoryImpl({
    required RestClient restClient,
    required Logger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient.unauth().post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );
    } on RestClientException catch (e, s) {
      if (e.statusCode == 400 &&
          e.response?.data['message']
              .toLowerCase()
              .contains('usuário já cadastrado')) {
        _log.error('Usuário já cadastrado', e, s);
        throw UserExistsException();
      }
      _log.error('Erro ao registrar usuário', e, s);
      throw Failure();
    }
  }

  @override
  Future<String> login(String login, String password) async {
    try {
      final result = await _restClient.unauth().post(
        '/auth/',
        data: {
          'login': login,
          'password': password,
          'social_login': false,
          'supplier_user': false
        },
      );
      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      _log.error('Error ao realizar login $e, $s');
      if (e.statusCode == 403) {
        _log.error('Usuario não encontrado $e, $s');
        throw UserNotfoundException();
      }
      throw Failure(message: 'Error ao realizar login');
    }
  }

  @override
  Future<ConfirmLoginModel> confirmLogin() async {
    try {
      final deviceToken = await PushNotification().getDeviceToken();
      final result = await _restClient.auth().patch(
        '/auth/confirm',
        data: {
          'ios_token': Platform.isIOS ? deviceToken : null,
          'android_token': Platform.isAndroid ? deviceToken : null,
        },
      );
      return ConfirmLoginModel.fromMap(result.data);
    } on RestClientException {
      throw Failure(message: 'Error ao confirmar Login');
    }
  }

  @override
  Future<UserModel> getUserLogged() async {
    try {
      final result = await _restClient.auth().get('/user/');
      return UserModel.fromMap(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Error ao buscar usuario', e, s);
      throw Failure(message: 'Error ao buscar usuario');
    }
  }

  @override
  Future<String> socialLogin(SocialNetworkModel socialModel) async {
    try {
      final result = await _restClient.unauth().post(
        '/auth/',
        data: {
          'login': socialModel.email,
          'social_login': true,
          'avatar': socialModel.avatar,
          'social_type': 'Google',
          'social_key': socialModel.id,
          'supplier_user': false,
        },
      );

      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      _log.error('Error ao realizar login $e, $s');
      throw Failure(message: 'Error ao realizar login');
    }
  }
}
