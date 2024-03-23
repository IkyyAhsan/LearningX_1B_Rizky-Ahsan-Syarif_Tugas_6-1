import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homework_6_1/app/data/medicine.dart';
import 'package:homework_6_1/app/helper/db_helper.dart';
import 'package:homework_6_1/app/modules/home/controllers/home_controller.dart';
import 'package:homework_6_1/app/utils/notification_api.dart';
import 'package:homework_6_1/app/data/notification.dart' as notif;


class AddScheduleController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController frequencyController;
  final List<TextEditingController> timeController =
      [TextEditingController()].obs;

  var db = DbHelper();
  final frequency = 0.obs;

  HomeController homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    NotificationApi.init();

    nameController = TextEditingController();
    frequencyController = TextEditingController();
  }

  void add(String name, int frequency) async {
    await db.insertMedicine(Medicine(name: name, frequency: frequency));

    var lastMedicineId = await db.getLastMedicineId();
    homeController.getAllMedicineData();
    Get.back();

    for (int i = 1; i <= frequency; i++) {
      await db.insertNotification(notif.Notification(
          idMedicine: lastMedicineId, time: timeController[i].text));
    }

    List<notif.Notification> notifications =
        await db.getNotificationsByMedicineId(lastMedicineId);

    for (int i = 0; i < notifications.length; i++) {
      print("making notification ${notifications[i].id}");
      await NotificationApi.scheduledNotification(
        id: notifications[i].id!,
        title: "Waktunya minum obat $name",
        body: "Minum obat agar cepat sembuh :)",
        payload: name,
        scheduledDate: Time(int.parse(notifications[i].time.split(':')[0]),
            int.parse(notifications[i].time.split(':')[1]), 0),
      ).then((value) => print("notif ${notifications[i].id} scheduled"));
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    frequencyController.dispose();
    for (var element in timeController) {
      element.dispose();
    }
  }
}
