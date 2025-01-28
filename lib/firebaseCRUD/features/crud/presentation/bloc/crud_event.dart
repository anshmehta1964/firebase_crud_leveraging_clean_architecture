part of 'crud_bloc.dart';

@immutable
sealed class TempCrudEvent {}

class TempDataFetchEvent extends TempCrudEvent{}

class TempInsertDataEvent extends TempCrudEvent{
  final String name;
  final String email;
  final String phone;
  TempInsertDataEvent({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class TempConnectionLostEvent extends TempCrudEvent{}

class TempConnectionGainedEvent extends TempCrudEvent{}

class TempTextChangedEvent extends TempCrudEvent{
  final String name;
  final String email;
  final String phone;
  TempTextChangedEvent({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class TempDataValidAndConnectedEvent extends TempCrudEvent{
  final String name;
  final String email;
  final String phone;
  TempDataValidAndConnectedEvent({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class TempDeleteDataEvent extends TempCrudEvent{
  final String name;
  TempDeleteDataEvent({required this.name});
}

class StoreOfflineDataEvent extends TempCrudEvent{
  final String name;
  final String email;
  final String phone;

  StoreOfflineDataEvent({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class RetrievingOfflineDataEvent extends TempCrudEvent{}