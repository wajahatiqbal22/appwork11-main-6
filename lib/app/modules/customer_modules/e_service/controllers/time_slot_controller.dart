import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../book_e_service/controllers/book_e_service_controller.dart';
import '../../../../models/timeslot_model.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../repositories/booking_repository.dart';
import '../../../../../common/ui.dart';
import 'package:intl/intl.dart';



class TimeSlotController extends GetxController {
  final now = DateTime.now().obs;
  final duration = 30.obs;
  final loading = false.obs;
  final startTime = TimeOfDay(hour: 0, minute: 0).obs;
  final endTime = TimeOfDay(hour: 0, minute: 0).obs;
  final timeslotData = Rxn<TimeslotModel>(TimeslotModel());
  final _bookingRepository = BookingRepository(Get.find<CustomerApiClient>());

  @override
  void onInit() {
    super.onInit();
  }

  void fetchTimeslotData() async {
    loading.value = true;
    BookEServiceController eServiceController = Get.find();
    String date =
        DateFormat('yyyy-M-dd').format(now.value).replaceAll('-', '/');
    String eProviderId = eServiceController.booking.value.eProvider!.id!;
    Get.log('Date: $date and EProviderID: $eProviderId');
    try {
      final response = await _bookingRepository.getTimeSlots(eProviderId, date);
      timeslotData.value = response;
      startTime.value = TimeOfDay(
          hour: int.parse(response.start!.split(':').first),
          minute: int.parse(response.start!.split(':').last));

      endTime.value = TimeOfDay(
          hour: int.parse(response.end!.split(':').first),
          minute: int.parse(response.end!.split(':').last));

      print(response.serviceDuration);

      duration.value = response.serviceDuration!;
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  final startDate = Rx<DateTime>(DateTime.now());

  final endDate = Rx<DateTime>(DateTime.now());

  Stream<List<String>?>? getBookingStreamMock(
      { DateTime? end,  DateTime? start}) async* {
    //   ...timeslotData.value!.booked!

    yield* Stream.value(null);
    BookEServiceController eServiceController = Get.find();
    String date =
        DateFormat('yyyy-M-dd').format(now.value).replaceAll('-', '/');
    String eProviderId = eServiceController.booking.value.eProvider!.id!;
    Get.log('Date: $date and EProviderID: $eProviderId');
    try {
      final response = await _bookingRepository.getTimeSlots(eProviderId, date);
      timeslotData.update((val) {
        val!.booked = response.booked;
        val.start = response.start;
        val.end = response.end;
      });
      startTime.value = TimeOfDay(
          hour: int.parse(response.start!.split(':').first),
          minute: int.parse(response.start!.split(':').last));

      endTime.value = TimeOfDay(
          hour: int.parse(response.end!.split(':').first),
          minute: int.parse(response.end!.split(':').last));

      startDate.value = DateTime(now.value.year, now.value.month, now.value.day,
          startTime.value.hour, startTime.value.minute);

      endDate.value = DateTime(now.value.year, now.value.month, now.value.day,
          endTime.value.hour, endTime.value.minute);

      duration.value = response.serviceDuration!;
      _generateBookingSlots();
      yield* Stream.value(timeslotData.value!.booked!);
    } catch (e) {
      print(e);
      //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      throw ('No Timeslots available');
    }
  }

  Future<dynamic> uploadBookingMock({ DateTime? newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));

    print('${newBooking} has been uploaded');
    BookEServiceController eServiceController = Get.find();
    eServiceController.booking.update((val) {
      val!.bookingAt = DateTime(
        newBooking!.year,
        newBooking.month,
        newBooking.day,
      ).add(Duration(minutes: newBooking.minute + newBooking.hour * 60));
      eServiceController.scheduled.value = true;
    });

    Get.back();
  }

  List<DateTimeRange> convertStreamResultMock({ dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    List<DateTimeRange> convert = [];

    final list = streamResult as List<String>;
    print(list);
    list.forEach((element) {
      final time = TimeOfDay(
          hour: int.parse(element.split(':').first),
          minute: int.parse(element.split(':').last));

      final effectiveDate = DateTime(now.value.year, now.value.month,
          now.value.day, time.hour, time.minute);

      convert.add(DateTimeRange(
          start: effectiveDate,
          end: effectiveDate.add(Duration(minutes: duration.value))));
    });

    return convert;
  }

  /// For calendar
  RxList<DateTime> allBookingSlots = <DateTime>[].obs;

  RxList<DateTimeRange> bookedSlots = <DateTimeRange>[].obs;

  RxInt selectedSlot = (-1).obs;

  final isUploading = false.obs;

  void _generateBookingSlots() {
    allBookingSlots.clear();
    allBookingSlots.addAll(List.generate(
        _maxServiceFitInADay(),
        (index) =>
            startDate.value.add(Duration(minutes: duration.value) * index)));
  }

  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate with 00:00-24:00
    int openingHours = 24;

    openingHours = DateTimeRange(start: startDate.value, end: endDate.value)
        .duration
        .inHours;
    print(openingHours);

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / duration.value).floor();
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots) {
      if (isOverLapping(slot.start, slot.end, checkSlot,
          checkSlot.add(Duration(minutes: duration.value)))) {
        result = true;
        break;
      }
    }
    return result;
  }

  void selectSlot(int idx) {
    selectedSlot.value = idx;
  }

  void resetSelectedSlot() {
    selectedSlot.value = -1;
  }

  void toggleUploading() {
    isUploading.value = !isUploading.value;
  }

  Future<void> generateBookedSlots(List<DateTimeRange> data) async {
    bookedSlots.clear();
    _generateBookingSlots();

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bookedSlots.add(item);
    }
  }

  DateTime generateNewBookingDateForUploading() {
    final bookingDate = allBookingSlots.elementAt(selectedSlot.value);

    return bookingDate;
  }
}

bool isOverLapping(DateTime firstStart, DateTime firstEnd, DateTime secondStart,
    DateTime secondEnd) {
  return getLatestDateTime(firstStart, secondStart)
      .isBefore(getEarliestDateTime(firstEnd, secondEnd));
}

DateTime getLatestDateTime(DateTime first, DateTime second) {
  return first.isAfterOrEq(second) ? first : second;
}

DateTime getEarliestDateTime(DateTime first, DateTime second) {
  return first.isBeforeOrEq(second) ? first : second;
}

String formatDateTime(DateTime dt) {
  return DateFormat.Hm().format(dt);
}

extension DateTimeExt on DateTime {
  bool isBeforeOrEq(DateTime second) {
    return isBefore(second) || isAtSameMomentAs(second);
  }

  bool isAfterOrEq(DateTime second) {
    return isAfter(second) || isAtSameMomentAs(second);
  }

  DateTime get startOfDay => DateTime(year, month, day, 0, 0);
  DateTime get endOfDay => DateTime(year, month, day + 1, 0, 0);
}
