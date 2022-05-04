import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customer_modules/global_widgets/block_button_widget.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/booking_calendar.dart';
import '../../global_widgets/text_field_widget.dart';
import 'package:intl/intl.dart';
import '../controllers/availability_controller.dart';

class AvailabilityPage extends GetView<AvailabilityController> {
  final controller=Get.put(AvailabilityController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Availability'),
        actions: [
          IconButton(
              onPressed: () {
                print(controller.showTimeSlot.value);
                if(controller.showTimeSlot.value)
                  {
                    controller.showTimeSlot.value = false;
                  }
                else{
                  controller.showTimeSlot.value = true;

                }
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Obx(
        () {
          if (controller.showTimeSlot.isTrue) {
            return BookingCalendarMain(
              convertStreamResultToDateTimeRanges:
                  controller.convertStreamResultMock,
              getBookingStream: controller.getBookingStreamMock,
              uploadBooking: controller.uploadBookingMock,
              bookingButtonText: 'Update',
              bookingButtonColor: Get.theme.colorScheme.secondary,
            );
          } else {
            return SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      isFirst: true,
                      controller: controller.dateController,
                      labelText: 'Date',
                      hintText: 'Select Date',
                      validator: (val) =>
                          GetUtils.isLengthGreaterOrEqual(val, 2)
                              ? null
                              : 'Required!',
                      readOnly: true,
                      onTap: () async {
                        var selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 1000)));
                        selectedDate ??= DateTime.now();
                        String date = DateFormat('yyyy-M-dd')
                            .format(selectedDate)
                            .replaceAll('-', '/');

                        controller.dateController.text = date;
                      },
                    ),
                    TextFieldWidget(
                      controller: controller.startController,
                      labelText: 'Start Time',
                      hintText: 'Select start time',
                      validator: (val) =>
                          GetUtils.isLengthGreaterOrEqual(val, 2)
                              ? null
                              : 'Required!',
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        selectedTime ??= TimeOfDay.now();
                        final time = selectedTime;
                        String bookedSlot = "${time.hour}:${time.minute}";
                        controller.startController.text = bookedSlot;
                      },
                    ),
                    TextFieldWidget(
                      controller: controller.endController,
                      labelText: 'End Time',
                      hintText: 'Select end time',
                      validator: (val) =>
                          GetUtils.isLengthGreaterOrEqual(val, 2)
                              ? null
                              : 'Required!',
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        selectedTime ??= TimeOfDay.now();
                        final time = selectedTime;
                        String bookedSlot = "${time.hour}:${time.minute}";
                        controller.endController.text = bookedSlot;
                      },
                    ),
                    TextFieldWidget(
                      controller: controller.recurringController,
                      validator: (val) =>
                          GetUtils.isLengthGreaterOrEqual(val, 2)
                              ? null
                              : 'Required!',
                      labelText: 'Recurring (Daily/Weekly/Monthly)',
                      hintText: 'Select',
                      readOnly: true,
                      onTap: () async {
                        var result = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              return SelectDialog<String>(
                                initialSelectedValue:
                                    controller.recurringController.text,
                                items: [
                                  SelectDialogItem('Daily', 'Daily'),
                                  SelectDialogItem('Weekly', 'Weekly'),
                                  SelectDialogItem('Monthly', 'Monthly'),
                                ],
                                title: 'Recurring',
                                submitText: 'Select',
                                cancelText: 'Cancel',
                              );
                            });

                        if (result != null) {
                          controller.recurringController.text = result;
                        }
                      },
                    ),
                    TextFieldWidget(
                      isLast: true,
                      controller: controller.durationController,
                      validator: (val) =>
                          GetUtils.isLengthGreaterOrEqual(val, 2)
                              ? null
                              : 'Required!',
                      labelText: 'Service duration',
                      hintText: 'Enter duration (e.g 10 or 30)',
                      keyboardType: TextInputType.number,
                    ),
                    BlockButtonWidget(
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          'Create Timeslots',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          controller.createTimeSlot();
                        }).paddingAll(20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
