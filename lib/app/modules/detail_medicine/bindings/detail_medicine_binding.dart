import 'package:get/get.dart';

import '../controllers/detail_medicine_controller.dart';

class DetailMedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMedicineController>(
      () => DetailMedicineController(),
    );
  }
}
