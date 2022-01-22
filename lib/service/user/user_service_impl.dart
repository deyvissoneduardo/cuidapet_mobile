import 'package:cuidaper_mobile/app/core/exceptions/failure.dart';
import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final Logger _log;

  UserServiceImpl({
    required UserRepository userRepository,
    required Logger log,
  })  : _userRepository = userRepository,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _userRepository.register(email, password);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao criar usuário no FirebaseAuth', e, s);
      throw Failure(message: 'Erro ao criar usuário no FirebaseAuth');
    }
  }

  @override
  Future<void> ligin(String login, String password) async {
    try {
      final access_token = await _userRepository.login(login, password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: login, password: password);
      _log.info('access_token => $access_token');
      _log.info('Login realizado com sucesso');
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao logar no FirebaseAuth', e, s);
      throw Failure(message: 'Erro ao fazer login');
    }
  }
}
