import 'package:cuidaper_mobile/app/core/exceptions/failure.dart';
import 'package:cuidaper_mobile/app/core/exceptions/social_login_canceled.dart';
import 'package:cuidaper_mobile/app/core/exceptions/user_exists_exception.dart';
import 'package:cuidaper_mobile/app/core/helpers/constants.dart';
import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/core/local_storage/local_security_storage.dart';
import 'package:cuidaper_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidaper_mobile/app/models/social_network_model.dart';
import 'package:cuidaper_mobile/app/models/social_type.dart';
import 'package:cuidaper_mobile/app/repositories/social/social_repository.dart';
import 'package:cuidaper_mobile/app/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final SocialRepository _socialRepository;
  final Logger _log;
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;

  UserServiceImpl({
    required UserRepository userRepository,
    required SocialRepository socialRepository,
    required Logger log,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
  })  : _userRepository = userRepository,
        _socialRepository = socialRepository,
        _log = log,
        _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _userRepository.register(email, password);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await login(email, password);
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao criar usuário no FirebaseAuth', e, s);
      throw Failure(message: 'Erro ao criar usuário no FirebaseAuth');
    }
  }

  @override
  Future<void> login(String login, String password) async {
    try {
      final accessToken = await _userRepository.login(login, password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: login, password: password);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
      _log.info('Logado');
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao logar no FirebaseAuth', e, s);
      throw Failure(message: 'Erro ao fazer login');
    }
  }

  Future<void> _saveAccessToken(String accessToken) =>
      _localStorage.write(Constants.accessTokenKey, accessToken);

  Future<void> _confirmLogin() async {
    final confirmModel = await _userRepository.confirmLogin();
    await _saveAccessToken(confirmModel.accessToken);
    await _localSecurityStorage.write(
        Constants.refreshTokenKey, confirmModel.refreshToken);
  }

  Future<void> _getUserData() async {
    final userLogged = await _userRepository.getUserLogged();
    await _localStorage.write<String>(
        Constants.userDataKey, userLogged.toJson());
  }

  @override
  Future<void> socialLogin(SocialType socialType) async {
    // Declaracoes
    String? email;

    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredential;
      final firebaseAuth = FirebaseAuth.instance;

      switch (socialType) {
        case SocialType.google:
          socialModel = await _socialRepository.googleLogin();
          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
        case SocialType.facebook:
          socialModel = await _socialRepository.facebookLogin();
          authCredential =
              FacebookAuthProvider.credential(socialModel.accessToken);
          break;
      }

      email = socialModel.email;
      // Processo comum do login com rede social
      await firebaseAuth.signInWithCredential(authCredential);
      final accessToken = await _userRepository.socialLogin(socialModel);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'account-exists-with-different-credential') {
        if (email != null) {
          final fetchMethods =
              await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
          var socialNetwork = '';
          if (fetchMethods.contains('google.com')) {
            socialNetwork = 'Google';
          }
          _log.error(
              'Usuário registrado com outro metodo de login ($socialNetwork, $socialType)');
          throw UserExistsException(
              'Você se regstrou com $socialNetwork, por favor utilize esse mesmo método');
        }
      }
      _log.error('Erro ao realizar login no Firebase', e, s);
      throw Failure(message: 'Erro ao realizar login no Firebase');
    } on SocialLoginCanceled {
      _log.error('Login cancelado');
      rethrow;
    }
  }
}
