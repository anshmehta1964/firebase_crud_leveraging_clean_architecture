import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meta/meta.dart';

import '../../domain/usecase/crud_usecase.dart';

part 'crud_event.dart';
part 'crud_state.dart';
List<String>? userDataList;
class TempCrudBloc extends Bloc<TempCrudEvent, TempCrudState> {
  final InsertDataUseCase insertDUC;
  final ReadDataUseCase readDUC;
  final DeleteDataUseCase deleteDUC;
  final OfflineDataUseCase offlineDataDUC;
  final OfflineDataRetrievalUseCase dataRetrievalDUC;
  final InsertingOfflineData insertOfflineDataDUC;
  final UpdateDataUseCase updateDUC;
  TempCrudBloc({
    required InsertDataUseCase insertusecase,
    required ReadDataUseCase Readusecase,
    required DeleteDataUseCase deleteusecase,
    required OfflineDataUseCase offlineusecase,
    required OfflineDataRetrievalUseCase dataRetDUC,
    required InsertingOfflineData insertoffDUC,
    required UpdateDataUseCase updateDataDUC,
   }) : insertDUC = insertusecase,
        readDUC = Readusecase, 
        deleteDUC = deleteusecase,
        offlineDataDUC = offlineusecase,
        dataRetrievalDUC = dataRetDUC,
        insertOfflineDataDUC = insertoffDUC,
        updateDUC = updateDataDUC, super(TempCrudInitialState()) {
    on<TempDataFetchEvent>((event, emit) async {
      // CollectionReference colReference = FirebaseFirestore.instance.collection(
      //     "anshDatabase");
      // QuerySnapshot querySnapshot = await colReference.get();
      print('Data Fetch Event Fired');
      Map<String, List<String>> data = await readDUC.call();
      List<String> nameList = data['name']!;
      List<String> emailList = data['email']!;
      List<String> phoneList = data['phone']!;
      // for (var docSnapshot in querySnapshot.docs) {
      //   nameList.add(docSnapshot.get("name"));
      //   emailList.add(docSnapshot.get("email"));
      //   phoneList.add(docSnapshot.get("phone"));
      // }

      emit(TempFetchingDataState(nameList: nameList, emailList: emailList, phoneList: phoneList));
    });
    on<TempInsertDataEvent>((event, emit) {
      // print('InsertDataEventFired');
      if (event.name == "" || event.email == "" || event.phone == "" ||
          !(EmailValidator.validate(event.email)) || event.phone.length < 10 || event.phone.length > 10) {
        // print('DataInvalidState');
        emit(TempDataInvalidState());
      } else {
        // print('DataValidState');
        emit(TempDataValidState());
      }
    });
    on<TempConnectionGainedEvent>((event, emit) {
      // print('ConnectionGainedEvent Fired!');
      // print('InternetConnectedState');
      emit(TempInternetConnectedState());
    });
    on<TempConnectionLostEvent>((event, emit) {
      // print('ConnectionLostEvent Fired!');
      print('TempInternetLostState');
      emit(TempInternetLostState());
    });

    on<TempTextChangedEvent>((event,emit){
      // print('Text Changed Event Fired!!');
      if(event.name == "" || event.phone == "" || event.email == "" || !(EmailValidator.validate(event.email)) || event.phone.length < 10 || event.phone.length > 10){
        emit(TempInvalidTextState());
      } else {
        emit(TempValidTextState());
      }
    });
    on<TempDataValidAndConnectedEvent>((event, emit){
      print('TempDataValidandConnectedEvent fired');
      insertDUC.call(CrudParameters(name: event.name, email: event.email, phone: event.phone));
    });
    
    on<TempDeleteDataEvent>((event, emit){
      print('Delete Data Event fired');
      deleteDUC.call(SingleParam(name: event.name));
    });

    on<StoreOfflineDataEvent>((event,emit){
      print('Store Offline Data event fired');
      offlineDataDUC.call(CrudParameters(name: event.name, email: event.email, phone: event.phone));
    });

    on<RetrievingOfflineDataEvent>((event,emit) async {
      print('Retrieving Offline Data event fired');
      userDataList = await dataRetrievalDUC.call();
      if(userDataList != null) {
        print('Offline data retrieved: $userDataList');
        insertOfflineDataDUC.call(userDataList!);
      } else {
        print("User data list is null");
      }
    });

    on<UpdateDataEvent>((event, emit){
      updateDataDUC.call(CrudParameters(name: event.name, email: event.email, phone: event.phone));
    });
  }
}
