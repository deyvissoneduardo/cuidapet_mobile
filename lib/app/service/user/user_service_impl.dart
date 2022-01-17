import 'package:cuidaper_mobile/app/core/exceptions/failure.dart';
import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidaper_mobile/app/service/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, s) {
      _log.error(
        'Error ao criar usuario no FirebaseAuth',
        error: e,
        stackTrace: s,
      );
      throw Failure(message: 'Error ao criar usuario no FirebaseAuth');
    }
  }
}
