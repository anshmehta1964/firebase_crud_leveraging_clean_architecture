import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../firebase crud bloc/firebase_crud_bloc.dart';

class InternetServices{
  final Connectivity _connectivity = Connectivity();
  final FirebaseCrudBloc firebaseCrudBloc = FirebaseCrudBloc();

  InternetServices(){
    _connectivity.onConnectivityChanged.listen(_crudConnectivityStatus);
  }
  // InternetServices internetServices = InternetServices();

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
      // isConnected = false;
    } else {
      firebaseCrudBloc.add(ConnectionGainedEvent());
      // isConnected = true;
      print('Internet Services :  Connected result  {$result}');
    }
  }
}