import 'dart:async';

import 'package:api_handling/firebaseCRUD/screens/crud%20screen/pages/crud_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../screens/crud screen/bloc/firebase_crud_bloc.dart';

class InternetServices{
  static StreamController<bool> streamController = StreamController();
  // Stream<bool> checkingConnection;
  static bool isConnected = false;
  final Connectivity _connectivity = Connectivity();
  final FirebaseCrudBloc firebaseCrudBloc = FirebaseCrudBloc();

  InternetServices(){
    _connectivity.onConnectivityChanged.listen(_crudConnectivityStatus);
  }

  Future<void> checkInitialStatus() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      print('Internet Services : Initial crudScreen connectivity result: $result');
      _crudConnectivityStatus(result);
    } catch (e) {
      print('Internet Services : Error in crud Screen: $e');
    }
  }

  void _crudConnectivityStatus(List<ConnectivityResult> result,) {
    print('Internet Services : Connectivity Changed');
    if (result.first == ConnectivityResult.none) {
      firebaseCrudBloc.add(ConnectionLostEvent());
      print('Internet Services :  No Connection');
      streamController.add(false);
    } else {
      firebaseCrudBloc.add(ConnectionGainedEvent());
      print('Internet Services :  Connected result  {$result}');
      streamController.add(true);
    }
  }
}