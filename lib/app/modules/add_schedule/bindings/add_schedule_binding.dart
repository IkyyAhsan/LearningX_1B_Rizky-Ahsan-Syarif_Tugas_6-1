import 'package:get/get.dart';

import '../controllers/add_schedule_controller.dart';

class AddScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddScheduleController>(
      () => AddScheduleController(),
    );
  }
}