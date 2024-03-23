import 'package:get/get.dart';

import '../modules/add_schedule/bindings/add_schedule_binding.dart';
import '../modules/add_schedule/views/add_schedule_view.dart';
import '../modules/detail_medicine/bindings/detail_medicine_binding.dart';
import '../modules/detail_medicine/views/detail_medicine_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SCHEDULE,
      page: () => AddScheduleView(),
      binding: AddScheduleBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MEDICINE,
      page: () => const DetailMedicineView(),
      binding: DetailMedicineBinding(),
    ),
  ];
}
