part of 'firebase_crud_bloc.dart';

class FirebaseCrudEvent {}

class DataFetchEvent extends FirebaseCrudEvent{}

class InsertDataEvent extends FirebaseCrudEvent{
  String name;
  String email;
  String phone;
  InsertDataEvent({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class ConnectionLostEvent extends FirebaseCrudEvent{}

class ConnectionGainedEvent extends FirebaseCrudEvent{}

class TextChangedEvent extends FirebaseCrudEvent{
  String name;
  String email;
  String phone;
  TextChangedEvent({
    required this.name,
    required this.email,
    required this.phone,
    });
}