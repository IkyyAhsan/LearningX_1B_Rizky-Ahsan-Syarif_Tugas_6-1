import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_schedule_controller.dart';

class AddScheduleView extends GetView<AddScheduleController> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('input medicine schedule'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Center(
              child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: const Text(
                  'input medicine schedule',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'Name',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: TextFormField(
                  controller: controller.frequencyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'Frequency',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    controller.frequency.value = int.parse(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              Obx(
                () => Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.frequency.value,
                      itemBuilder: (context, index) {
                        final timeController = TextEditingController();
                        return Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            controller: timeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: 'Time',
                            ),
                            textInputAction: TextInputAction.next,
                            onTap: () {
                              displayTimePicker(context, timeController);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    )),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text('Add'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.add(controller.nameController.text,
                            int.parse(controller.frequencyController.text));
                      };
                    },
                  )),
            ],
          )),
        ));
  }

  Future displayTimePicker(
      BuildContext context, TextEditingController textfieldController) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      textfieldController.text = "${time.hour}:${time.minute}";
      controller.timeController.add(textfieldController);
    }
  }
}

