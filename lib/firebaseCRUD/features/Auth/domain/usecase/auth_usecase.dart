import 'package:api_handling/firebaseCRUD/core/usecase/usecase.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCaseWithParams<Type, Parameters> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  call(Parameters params) {
    // print('UseCase : User Signup called');
    authRepository.signInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLogIn implements UseCaseWithParams<Type, Parameters> {
  final AuthRepository authRepository;
  const UserLogIn(this.authRepository);

  @override
  Future<bool> call(Parameters params) async {
    // print('UseCase : User Signup called');
    bool user = await authRepository.logInWithEmailPassword(
        email: params.email, password: params.password);
    return user;
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
