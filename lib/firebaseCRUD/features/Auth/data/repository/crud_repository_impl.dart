import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_local_data_source.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/repository/crud_repository.dart';

import '../datasource/auth_remote_data_source.dart';

class CrudRepositoryImpl implements CrudRepository{
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDataSource localDataSource;
  CrudRepositoryImpl(this.remoteDatasource, this.localDataSource);
  @override
  void insertData({required String name, required String email, required String phone}) {
    print('Crud Repo Impl : InsertData()');
   remoteDatasource.insertData(name: name, email: email, phone: phone);
  }

  @override
  Future<Map<String,List<String>>> readData() {
    print('Crud Repo Impl : ReadData()');
    return remoteDatasource.readData();
  }

  @override
  void updateData() {
    // TODO: implement updateData
  }

  @override
  void deleteData(String name){
    print('Crud Repo Impl : Delete Data()');
    remoteDatasource.deleteData(name);
  }

  @override
  void storeOfflineData({required String name, required String email, required String phone}) {
    print('Crud Repo Impl : Storing offline data()');
   localDataSource.storeOfflineData(name, email, phone);
  }

  @override
  void offlineDataRetrieval() {
    localDataSource.offlineDataRetrieval();
  }

}