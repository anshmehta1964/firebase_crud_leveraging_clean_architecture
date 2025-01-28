import 'dart:async';
import 'package:api_handling/firebaseCRUD/core/singletons/shared_pref_singleton.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/bloc/crud_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/Auth/domain/usecase/domain_usercase.dart';
import '../../features/crud/data/datasource/crud_local_datasource.dart';
import '../../features/crud/data/datasource/crud_remote_datasource.dart';
import '../../features/crud/data/repository/crud_repository_impl.dart';
import '../../screens/crud screen/bloc/firebase_crud_bloc.dart';

class InternetServices {
  static StreamController<bool> streamController = StreamController();
  static bool isConnected = false;
  final Connectivity _connectivity = Connectivity();
  final FirebaseCrudBloc firebaseCrudBloc = FirebaseCrudBloc();
  late TempCrudBloc tempCrudBloc = TempCrudBloc(
    insertusecase: InsertDataUseCase(CrudRepositoryImpl(
        CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
        CrudLocalDatasourceImpl(SingletonSharedPreference.instance.prefs))),
    Readusecase: ReadDataUseCase(CrudRepositoryImpl(
        CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
        CrudLocalDatasourceImpl(SingletonSharedPreference.instance.prefs))),
    deleteusecase: DeleteDataUseCase(CrudRepositoryImpl(
        CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
        CrudLocalDatasourceImpl(SingletonSharedPreference.instance.prefs))),
    offlineusecase: OfflineDataUseCase(CrudRepositoryImpl(
        CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
        CrudLocalDatasourceImpl(SingletonSharedPreference.instance.prefs))),
    dataRetDUC: OfflineDataRetrievalUseCase(CrudRepositoryImpl(
        CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
        CrudLocalDatasourceImpl(SingletonSharedPreference.instance.prefs))),
  );

  InternetServices() {
    _connectivity.onConnectivityChanged.listen(_crudConnectivityStatus);
  }

  Future<void> checkInitialStatus() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      print(
          'Internet Services : Initial crudScreen connectivity result: $result');
      _crudConnectivityStatus(result);
    } catch (e) {
      print('Internet Services : Error in crud Screen: $e');
    }
  }

  void _crudConnectivityStatus(
    List<ConnectivityResult> result,
  ) {
    print('Internet Services : Connectivity Changed');
    if (result.first == ConnectivityResult.none) {
      firebaseCrudBloc.add(ConnectionLostEvent());
      tempCrudBloc.add(TempConnectionLostEvent());
      print('Internet Services :  No Connection');
      streamController.add(false);
    } else {
      firebaseCrudBloc.add(ConnectionGainedEvent());
      tempCrudBloc.add(TempConnectionGainedEvent());
      print('Internet Services :  Connected result  {$result}');
      streamController.add(true);
    }
  }

}
