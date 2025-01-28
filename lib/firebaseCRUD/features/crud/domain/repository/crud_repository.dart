abstract interface class CrudRepository{

  void insertData({
    required String name,
    required String email,
    required String phone
  });

  void storeOfflineData({
    required String name,
    required String email,
    required String phone,
  });

  Future<Map<String,List<String>>> readData();

  void updateData(){}

  void deleteData(String name){}

  void offlineDataRetrieval();

}