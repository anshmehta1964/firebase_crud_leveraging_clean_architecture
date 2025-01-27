import 'package:api_handling/firebaseCRUD/core/usecase/usecase.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/repository/auth_repository.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/repository/crud_repository.dart';

class UserSignUp implements UseCaseWithParams<Type,Parameters>{
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  call(Parameters params) {
    print('UseCase : User Signup called');
    authRepository.signInWithEmailPassword(email: params.email, password: params.password);
  }
}

class UserLogIn implements UseCaseWithParams<Type,Parameters>{
  final AuthRepository authRepository;
  const UserLogIn(this.authRepository);

  @override
  Future<bool> call(Parameters params) async {
    print('UseCase : User Signup called');
    bool user = await authRepository.logInWithEmailPassword(email: params.email, password: params.password);
    return user;
  }
}

class InsertDataUseCase implements UseCaseWithParams<Type,CrudParameters>{
  final CrudRepository crudRepository;
  const InsertDataUseCase(this.crudRepository);
  @override
  call(CrudParameters params) {
    print('Use Case : Insert data()');
    crudRepository.insertData(name: params.name, email: params.email, phone: params.phone);
  }
}

class ReadDataUseCase implements UseCaseWithoutParams{
  final CrudRepository crudRepository;
  const ReadDataUseCase(this.crudRepository);
  @override
  Future<Map<String, List<String>>> call() {
    print('Use Case : ReadData()');
    return crudRepository.readData();
  }
}

class DeleteDataUseCase implements UseCaseWithParams<Type,SingleParam>{
  final CrudRepository crudRepository;
  DeleteDataUseCase(this.crudRepository);
  @override
  call(SingleParam param) {
    print('Use Case : Delete Data()');
    crudRepository.deleteData(param.name);
  }
}

class OfflineDataUseCase implements UseCaseWithParams<Type,CrudParameters>{
  final CrudRepository crudRepository;
  OfflineDataUseCase(this.crudRepository);

  @override
  call(CrudParameters params) {
    print('Use case : Offline Data Storing()');
    crudRepository.storeOfflineData(name: params.name, email: params.email, phone: params.phone);
  }

}

class CrudParameters{
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

class SingleParam{
  final String name;
  SingleParam({required this.name});
}
