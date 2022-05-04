import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import '../../../provider_modules/global_widgets/booking_calendar.dart';
import '../controllers/time_slot_controller.dart';
import '../../global_widgets/booking_calendar.dart';

class TimeSlotPage extends GetView<TimeSlotController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Timeslot'),
      ),
      body: Center(
          child: BookingCalendarMain(
        convertStreamResultToDateTimeRanges: controller.convertStreamResultMock,
        getBookingStream: controller.getBookingStreamMock,
        uploadBooking: controller.uploadBookingMock,
        bookingButtonText: 'Proceed',
        bookingButtonColor: Get.theme.colorScheme.secondary,
        // start: controller.startDate.value,
        // duration: controller.duration.value,
        // end: controller.endDate.value,
        // onNewDateSelected: (newDate) {
        //   print(newDate);
        //   controller.now.value = newDate;
        // },
      )),
    );
  }
}
