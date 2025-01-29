abstract interface class CrudRepository {
  void insertData(
      {required String name, required String email, required String phone});

  void storeOfflineData({
    required String name,
    required String email,
    required String phone,
  });

  Future<Map<String, List<String>>> readData();

  void deleteData(String name) {}

  Future<List<String>?> offlineDataRetrieval();

  void offlineDataInserted(List<String> data);

  void updateData(
      {required String name, required String email, required String phone});
}
