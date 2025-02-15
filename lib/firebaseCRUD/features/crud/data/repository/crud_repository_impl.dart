import '../../domain/repository/crud_repository.dart';
import '../datasource/crud_local_datasource.dart';
import '../datasource/crud_remote_datasource.dart';

class CrudRepositoryImpl implements CrudRepository {
  final CrudRemoteDataSource remoteDatasource;
  final CrudLocalDataSource localDataSource;
  CrudRepositoryImpl(this.remoteDatasource, this.localDataSource);
  @override
  void insertData(
      {required String name, required String email, required String phone}) {
    print('Crud Repo Impl : InsertData()');
    remoteDatasource.insertData(name: name, email: email, phone: phone);
  }

  @override
  Future<Map<String, List<String>>> readData() {
    print('Crud Repo Impl : ReadData()');
    return remoteDatasource.readData();
  }

  @override
  void updateData(
      {required String name, required String email, required String phone}) {
    print('Crud Repo Impl : updateData()');
    remoteDatasource.updateData(name: name, email: email, phone: phone);
    // print('UpdateData is called : FirebaseServices');
  }

  @override
  void deleteData(String name) {
    print('Crud Repo Impl : Delete Data()');
    remoteDatasource.deleteData(name);
  }

  @override
  void storeOfflineData(
      {required String name, required String email, required String phone}) {
    print('Crud Repo Impl : Storing offline data()');
    localDataSource.storeOfflineData(name, email, phone);
  }

  @override
  Future<List<String>?> offlineDataRetrieval() async {
    List<String>? userDataList = await localDataSource.offlineDataRetrieval();
    // print('Crud Repo Impl : userDataList has data : $userDataList');
    return userDataList;
  }

  @override
  void offlineDataInserted(List<String> data) {
    print('Crud Repo Impl : Offline Data Inserted()');
    remoteDatasource.offlineDataInserted(data);
  }
}
