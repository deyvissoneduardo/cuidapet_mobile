abstract class UserService {
  Future<void> register(String email, String password);
  Future<void> ligin(String login, String password);
}
