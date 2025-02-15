import '../../../../core/usecase/usecase.dart';
import '../repository/crud_repository.dart';

class InsertDataUseCase implements UseCaseWithParams<Type, CrudParameters> {
  final CrudRepository crudRepository;
  const InsertDataUseCase(this.crudRepository);
  @override
  call(CrudParameters params) {
    // print('Use Case : Insert data()');
    crudRepository.insertData(
        name: params.name, email: params.email, phone: params.phone);
  }
}

class ReadDataUseCase implements UseCaseWithoutParams {
  final CrudRepository crudRepository;
  const ReadDataUseCase(this.crudRepository);
  @override
  Future<Map<String, List<String>>> call() {
    // print('Use Case : ReadData()');
    return crudRepository.readData();
  }
}

class DeleteDataUseCase implements UseCaseWithParams<Type, SingleParam> {
  final CrudRepository crudRepository;
  DeleteDataUseCase(this.crudRepository);
  @override
  call(SingleParam param) {
    // print('Use Case : Delete Data()');
    crudRepository.deleteData(param.name);
  }
}

class OfflineDataUseCase implements UseCaseWithParams<Type, CrudParameters> {
  final CrudRepository crudRepository;
  OfflineDataUseCase(this.crudRepository);

  @override
  call(CrudParameters params) {
    print('Use case : Offline Data Storing()');
    crudRepository.storeOfflineData(
        name: params.name, email: params.email, phone: params.phone);
  }
}

class OfflineDataRetrievalUseCase implements UseCaseWithoutParams {
  final CrudRepository crudRepository;
  OfflineDataRetrievalUseCase(this.crudRepository);
  @override
  Future<List<String>?> call() async {
    print('Use case : Offline Data Retrieval()');
    List<String>? userDataList = await crudRepository.offlineDataRetrieval();
    print('Use Case: userDataList has Data : $userDataList');
    return userDataList;
  }
}

class InsertingOfflineData implements UseCaseWithParams<Type, List<String>> {
  final CrudRepository crudRepository;
  InsertingOfflineData(this.crudRepository);
  @override
  call(List<String> data) {
    print('Use case inserting following data: $data');
    crudRepository.offlineDataInserted(data);
  }
}

class UpdateDataUseCase implements UseCaseWithParams<Type, CrudParameters> {
  final CrudRepository crudRepository;
  UpdateDataUseCase(this.crudRepository);
  @override
  call(CrudParameters params) {
    crudRepository.updateData(
        name: params.name, email: params.email, phone: params.phone);
  }
}

class CrudParameters {
  final String name;
  final String email;
  final String phone;
  const CrudParameters({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class Parameters {
  final String email;
  final String password;
  Parameters({required this.email, required this.password});
}

class SingleParam {
  final String name;
  SingleParam({required this.name});
}
