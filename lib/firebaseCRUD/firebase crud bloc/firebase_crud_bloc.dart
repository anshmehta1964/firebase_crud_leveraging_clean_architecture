import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

part 'firebase_crud_event.dart';
part 'firebase_crud_state.dart';

class FirebaseCrudBloc extends Bloc<FirebaseCrudEvent, FirebaseCrudState> {
  FirebaseCrudBloc() : super(FirebaseCrudInitialState()) {
    on<DataFetchEvent>((event, emit) async {
      CollectionReference colReference = FirebaseFirestore.instance.collection(
          "anshDatabase");
      QuerySnapshot querySnapshot = await colReference.get();
      List<String> nameList = [];
      List<String>emailList = [];
      List<String>phoneList = [];
      for (var docSnapshot in querySnapshot.docs) {
        nameList.add(docSnapshot.get("name"));
        emailList.add(docSnapshot.get("email"));
        phoneList.add(docSnapshot.get("phone"));
      }
      // List<String>nameList = querySnapshot.docs.map((doc) => doc.get("name")).toList() ;
      //  = querySnapshot.docs.map((doc) => doc.get("email")).toList() ;
      // List<dynamic>phoneList = querySnapshot.docs.map((doc) => doc.get("phone")).toList();
      print('FetchingDataState');
      emit(FetchingDataState(nameList: nameList, emailList: emailList, phoneList: phoneList));
    });
    on<InsertDataEvent>((event, emit) {
      print('InsertDataEventFired');
      if (event.name == "" || event.email == "" || event.phone == "" ||
          !(EmailValidator.validate(event.email)) || event.phone.length < 10 || event.phone.length > 10) {
        print('DataInvalidState');
        emit(DataInvalidState());
      } else {
        print('DataValidState');
        emit(DataValidState());
      }
    });
    on<ConnectionGainedEvent>((event, emit) {
      print('ConnectionGainedEvent Fired!');
      print('InternetConnectedState');
      emit(InternetConnectedState());
    });
    on<ConnectionLostEvent>((event, emit) {
      print('ConnectionLostEvent Fired!');
      print('InternetLostState');
      emit(InternetLostState());
    });
    // on<CardClickedEvent>((event, emit) {
    //   print('Card Clicked event fired');
    //   emit(UpdateButtonEnableState());
    // });

    on<TextChangedEvent>((event,emit){
      print('Text Changed Event Fired!!');
      if(event.name == "" || event.phone == "" || event.email == "" || !(EmailValidator.validate(event.email)) || event.phone.length < 10 || event.phone.length > 10){
        emit(InvalidTextState());
      } else {
        emit(ValidTextState());
      }
    });
  }
}
