import 'package:get/get.dart';
import 'package:homework_6_1/app/data/medicine.dart';
import 'package:homework_6_1/app/helper/db_helper.dart';

class HomeController extends GetxController with StateMixin<List<Medicine>> {
  var db = DbHelper();
  List<Medicine> listMedicines = <Medicine>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllMedicineData();
  }

  Future getAllMedicineData() async {
    change(null, status: RxStatus.loading());
    listMedicines.clear();
    final List<Medicine> medicines = await db.queryAllRowsMedicine();
    listMedicines.addAll(medicines);
    if (listMedicines.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(listMedicines, status: RxStatus.success());
    }
  }
}