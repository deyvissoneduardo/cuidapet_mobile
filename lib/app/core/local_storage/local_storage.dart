abstract class LocalStorage {
  Future<P?> read<P>(String key);
  Future<void> write<P>(String key, P valeu);
  Future<bool> contains(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
