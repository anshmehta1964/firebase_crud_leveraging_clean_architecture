part of 'crud_bloc.dart';

@immutable
sealed class TempCrudState {}

class TempCrudInitialState extends TempCrudState {}

class TempFetchingDataState extends TempCrudState {
  final List<String> nameList;
  final List<String> emailList;
  final List<String> phoneList;
  TempFetchingDataState({
    required this.nameList,
    required this.emailList,
    required this.phoneList,
  });
}

class TempDataValidState extends TempCrudState {}

class TempDataInvalidState extends TempCrudState {}

class TempInternetConnectedState extends TempCrudState {}

class TempInternetLostState extends TempCrudState {}

// class UpdateButtonEnableState extends FirebaseCrudState{}

class TempValidTextState extends TempCrudState {}

class TempInvalidTextState extends TempCrudState {}

class TempDataValidAndConnectedState extends TempCrudState {}

class DataUpdatedState extends TempCrudState{}
