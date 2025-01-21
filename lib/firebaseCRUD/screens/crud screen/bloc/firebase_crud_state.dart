part of 'firebase_crud_bloc.dart';

class FirebaseCrudState {}

class FirebaseCrudInitialState extends FirebaseCrudState {}

class FetchingDataState extends FirebaseCrudState {
  List<String>nameList;
  List<String>emailList;
  List<String>phoneList;
  FetchingDataState({
    required this.nameList,
    required this.emailList,
    required this.phoneList,
  });
}

class DataValidState extends FirebaseCrudState{}

class DataInvalidState extends FirebaseCrudState{}

class InternetConnectedState extends FirebaseCrudState{}

class InternetLostState extends FirebaseCrudState{}

// class UpdateButtonEnableState extends FirebaseCrudState{}

class ValidTextState extends FirebaseCrudState{}

class InvalidTextState extends FirebaseCrudState{}
