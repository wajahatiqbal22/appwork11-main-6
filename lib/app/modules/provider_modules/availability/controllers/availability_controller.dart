import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/repositories/booking_repository.dart';
import '../../../../models/timeslot_model.dart';
import 'package:intl/intl.dart';
import '../../../../services/auth_service.dart';
import '../../../../../common/ui.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

class AvailabilityController extends GetxController {
  final now = DateTime.now().obs;
  final duration = 30.obs;
  final loading = false.obs;
  final startTime = TimeOfDay(hour: 0, minute: 0).obs;
  final endTime = TimeOfDay(hour: 0, minute: 0).obs;
  final timeslotData = Rxn<TimeslotModel>(TimeslotModel());
  late TextEditingController dateController;
  late TextEditingController startController;
  late TextEditingController endController;
  late TextEditingController durationController;
  late TextEditingController recurringController;
  final available = true.obs;
  final showTimeSlot = true.obs;
  final formKey = GlobalKey<FormState>();

  final _bookingRepository = BookingRepository(Get.find<ProviderApiClient>());

  @override
  void onInit() {
    dateController = TextEditingController();
    startController = TextEditingController();
    endController = TextEditingController();
    durationController = TextEditingController();
    recurringController = TextEditingController();
    super.onInit();
  }

  clear() {
    dateController.clear();
    startController.clear();
    endController.clear();
    durationController.clear();
    recurringController.clear();
  }

/*
  void fetchTimeslotData() async {
    loading.value = true;
    AuthService authService = Get.find();
    String date =
        DateFormat('yyyy-M-dd').format(now.value).replaceAll('-', '/');
    String eProviderId = authService.user.value.id;
    // eServiceController.booking.value.eProvider!.id!;
    Get.log('Date: $date and EProviderID: $eProviderId');
    try {
      final response = await _bookingRepository.getTimeSlots(eProviderId, date);
      timeslotData.value = response;
      startTime.value = TimeOfDay(
          hour: int.parse(response.start.split(':').first),
          minute: int.parse(response.start.split(':').last));

      endTime.value = TimeOfDay(
          hour: int.parse(response.end.split(':').first),
          minute: int.parse(response.end.split(':').last));

      duration.value = response.serviceDuration;
      showTimeSlot.value = true;
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: e.toString() + ', create one'));
    } finally {
      loading.value = false;
    }
  }
*/

  void fetchTimeslotData() async {
    loading.value = true;
    AuthService authService = Get.find();
    String date =
    DateFormat('yyyy-M-dd').format(now.value).replaceAll('-', '/');
    String eProviderId = authService.user.value.id!;
    // eServiceController.booking.value.eProvider!.id!;
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

      duration.value = response.serviceDuration!;
      showTimeSlot.value = true;
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: e.toString() + ', create one'));
    } finally {
      loading.value = false;
    }
  }
  final startDate = Rx<DateTime>(DateTime.now());

  final endDate = Rx<DateTime>(DateTime.now());

  Stream<List<String>?>? getBookingStreamMock(
      { DateTime? end,  DateTime? start}) async* {
    yield* Stream.value(null);
    AuthService authService = Get.find();
    String date =
        DateFormat('yyyy-M-dd').format(now.value).replaceAll('-', '/');
    String eProviderId = authService.user.value.id!;
    // eServiceController.booking.value.eProvider!.id!;
    Get.log('Date: $date and EProviderID: $eProviderId');
    try {
      final response = await _bookingRepository.getTimeSlots(eProviderId, date);
      print("slots::");
      print(response);
      timeslotData.update((val) {

        val!.booked = response.booked;
        val.start = response.start;
        val.end = response.end;
        val.serviceDuration = response.serviceDuration;
        // val.start=DateFormat("hh:mm a").format(DateFormat("hh:mm").parse(response.start!)).toString();
        // val.end=DateFormat("hh:mm a").format(DateFormat("hh:mm").parse(response.end!)).toString();

      });
      print(timeslotData.value);
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
      yield* Stream.value(timeslotData.value!.booked);
    } catch (e) {
      print(e);
      //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      throw ('No Timeslots available \nYou can create one by clicking the Pen Icon at the top-right');
    }
  }

  Future<dynamic> uploadBookingMock({ List<DateTime>? bookings}) async {
    await Future.delayed(const Duration(seconds: 1));

    AuthService authService = Get.find();

    timeslotData.update((val) {
      String date =
          DateFormat('yyyy-M-dd').format(now.value).replaceAll('-', '/');
      List<String> bookedSlots = [];
      bookings!.forEach((newBooking) {
        final time = TimeOfDay.fromDateTime(newBooking);
        String bookedSlot = "${time.hour}:${time.minute}";
        bookedSlots.add(bookedSlot);
      });

      if (bookedSlots.isEmpty) return;

      print('${bookedSlots} has been uploaded');

      val!.booked = [...val.booked!, ...bookedSlots];
      val.date = date;
      val.eProviderId = int.parse(authService.user.value.id!);
    });

    final response =
        await _bookingRepository.updateTimeslot(timeslotData.value!);

    timeslotData.update((val) {
      val!.booked = response.booked;
      val.start = response.start;
      val.end = response.end;
      val.serviceDuration = response.serviceDuration;
    });

    startTime.value = TimeOfDay(
        hour: int.parse(response.start!.split(':').first),
        minute: int.parse(response.start!.split(':').last));

    endTime.value = TimeOfDay(
        hour: int.parse(response.end!.split(':').first),
        minute: int.parse(response.end!.split(':').last));

    duration.value = response.serviceDuration!;
    showTimeSlot.value = true;
    // fetchTimeslotData();
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

  Future<void> createTimeSlot() async {
    if (!formKey.currentState!.validate()) return;
    loading.value = true;
    AuthService authService = Get.find();
    int recurring;
    switch (recurringController.text) {
      case 'Daily':
        recurring = 1;
        break;
      case 'Weekly':
        recurring = 2;
        break;
      case 'Monthly':
        recurring = 3;
        break;
      default:
        recurring = null!;
    }

    try {
      final newTimeSlot = TimeslotModel(
        serviceDuration: int.tryParse(durationController.text),
        start: startController.text,
        end: endController.text,
        cleanup: 0,
        date: dateController.text,
        status: available.isTrue ? 1 : 0,
        recurring: recurring,
        eProviderId: int.parse(authService.user.value.id!),
      );

      print(newTimeSlot.toJson());

      final response = await _bookingRepository.createTimeslot(newTimeSlot);

      timeslotData.value = response;
      startTime.value = TimeOfDay(
          hour: int.parse(response.start!.split(':').first),
          minute: int.parse(response.start!.split(':').last));

      endTime.value = TimeOfDay(
          hour: int.parse(response.end!.split(':').first),
          minute: int.parse(response.end!.split(':').last));

      duration.value = response.serviceDuration!;
      showTimeSlot.value = true;
      clear();
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: 'Couldn\'t update timeslot, try Again'));
    } finally {
      loading.value = false;
    }
  }

  /// For calendar
  RxList<DateTime> allBookingSlots = <DateTime>[].obs;

  RxList<DateTimeRange> bookedSlots = <DateTimeRange>[].obs;

  RxInt selectedSlot = (-1).obs;

  RxList<int> selectedSlots = <int>[].obs;

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
    if (selectedSlots.contains(idx)) {
      selectedSlots.remove(idx);
    } else {
      selectedSlots.add(idx);
    }
  }

  void resetSelectedSlots() {
    selectedSlots.clear();
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

  List<DateTime> generateNewBookingDateForUploading() {
    List<DateTime> bookingDates = [];
    selectedSlots.forEach((element) {
      final bookingDate = allBookingSlots.elementAt(element);
      bookingDates.add(bookingDate);
    });

    return bookingDates;
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
