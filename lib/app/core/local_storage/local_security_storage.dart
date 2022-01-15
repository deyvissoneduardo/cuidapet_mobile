abstract class LocalSecurityStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String valeu);
  Future<bool> contains(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
