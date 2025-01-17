import 'package:api_handling/firebaseCRUD/networkController/controller.dart';
import 'package:get/get.dart';

class DependencyInjection{

  static void init(){
    Get.put<InternetController>(InternetController(),permanent: true);
  }
}