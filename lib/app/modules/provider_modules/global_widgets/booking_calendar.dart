import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/provider_modules/availability/controllers/availability_controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'booking_slot.dart';
import 'common_button.dart';
import 'common_card.dart';

class BookingSlotController extends GetxController {
   DateTime? base;

  final DateTime? serviceOpening;
  final DateTime? serviceClosing;
  final int? duration;

  RxList<DateTime>? allBookingSlots = <DateTime>[].obs;

  RxList<DateTimeRange>? bookedSlots = <DateTimeRange>[].obs;

  RxInt selectedSlot = (-1).obs;
  BookingSlotController({
     this.serviceOpening,
     this.serviceClosing,
     this.duration,
  }) {
    base = serviceOpening;
    _generateBookingSlots();
  }
  final isUploading = false.obs;

  void _generateBookingSlots() {
    allBookingSlots!.clear();
    allBookingSlots!.value = List.generate(_maxServiceFitInADay(),
        (index) => base!.add(Duration(minutes: duration!) * index));
  }

  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate with 00:00-24:00
    int openingHours = 24;
    if (serviceOpening != null && serviceClosing != null) {
      openingHours = DateTimeRange(start: serviceOpening!, end: serviceClosing!)
          .duration
          .inHours;
    }

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / duration!).floor();
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots!.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots!) {
      if (isOverLapping(slot.start, slot.end, checkSlot,
          checkSlot.add(Duration(minutes: duration!)))) {
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
    bookedSlots!.clear();
    _generateBookingSlots();

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bookedSlots!.add(item);
    }
  }

  DateTime generateNewBookingDateForUploading() {
    final bookingDate = allBookingSlots!.elementAt(selectedSlot.value);

    return bookingDate;
  }
}

class BookingCalendarMain extends StatefulWidget {
  const BookingCalendarMain({
    Key? key,
     this.getBookingStream,
     this.convertStreamResultToDateTimeRanges,
     this.uploadBooking,
    this.bookingExplanation,
    this.bookingGridCrossAxisCount,
    this.bookingGridChildAspectRatio,
    this.formatDateTime,
    this.bookingButtonText,
    this.bookingButtonColor,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.bookedSlotText,
    this.selectedSlotText,
    this.availableSlotText,
    this.gridScrollPhysics,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key);

  final Stream<List<String>?>? Function(
      { DateTime start,  DateTime end})? getBookingStream;
  final Future<dynamic> Function({ List<DateTime> bookings})?
      uploadBooking;
  final List<DateTimeRange> Function({ dynamic streamResult})?
      convertStreamResultToDateTimeRanges;

  ///Customizable
  final Widget? bookingExplanation;
  final int? bookingGridCrossAxisCount;
  final double? bookingGridChildAspectRatio;
  final String Function(DateTime dt)? formatDateTime;
  final String? bookingButtonText;
  final Color? bookingButtonColor;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final ScrollPhysics? gridScrollPhysics;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();

    startOfDay = now.startOfDay;
    endOfDay = now.endOfDay;
    _focusedDay = now;
    _selectedDay = now;
  }

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

   DateTime? _selectedDay;
   DateTime? _focusedDay;
   DateTime? startOfDay;
   DateTime? endOfDay;

  void selectNewDateRange() {
    AvailabilityController controller = Get.find();
    startOfDay = _selectedDay!.startOfDay;
    endOfDay = _selectedDay!.add(const Duration(days: 1)).endOfDay;

    controller.now.value = startOfDay!;

    controller.resetSelectedSlots();
  }

  @override
  Widget build(BuildContext context) {
    AvailabilityController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          CommonCard(
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 1000)),
              focusedDay: _focusedDay!,
              calendarFormat: _calendarFormat,
              calendarStyle: const CalendarStyle(isTodayHighlighted: false),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  selectNewDateRange();
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 8),
          widget.bookingExplanation ??
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BookingExplanation(
                      color: widget.availableSlotColor ?? Colors.greenAccent,
                      text: widget.availableSlotText ?? "Available"),
                  /*BookingExplanation(
                      color: widget.selectedSlotColor ?? Colors.orangeAccent,
                      text: widget.selectedSlotText ?? "Selected"),*/
                  BookingExplanation(
                      color: widget.bookedSlotColor ?? Colors.redAccent,
                      text: widget.bookedSlotText ?? "Booked"),
                ],
              ),
          const SizedBox(height: 8),
          StreamBuilder<dynamic>(
            stream: widget.getBookingStream!(start: startOfDay!, end: endOfDay!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Expanded(
                  child: widget.errorWidget ??
                      Center(
                        child: Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                );
              }

              if (!snapshot.hasData) {
                return Expanded(
                  child: widget.loadingWidget ??
                      const Center(child: CircularProgressIndicator()),
                );
              }

              ///this snapshot should be converted to List<DateTimeRange>
              final data = snapshot.requireData;
              controller.generateBookedSlots(widget
                  .convertStreamResultToDateTimeRanges!(streamResult: data));

              return Expanded(
                child: GridView.builder(
                  physics:
                      widget.gridScrollPhysics ?? const BouncingScrollPhysics(),
                  itemCount: controller.allBookingSlots.length,
                  itemBuilder: (context, index) => Obx(() => BookingSlot(
                        isBooked: controller.isSlotBooked(index),
                        isSelected:
                            controller.selectedSlots.value.contains(index),
                        onTap: () => controller.selectSlot(index),
                        child: Center(
                          child: Text(
                            widget.formatDateTime?.call(controller
                                    .allBookingSlots
                                    .elementAt(index)) ??
                                formatDateTime(controller.allBookingSlots
                                    .elementAt(index)),
                          ),
                        ),
                      )),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.bookingGridCrossAxisCount ?? 3,
                    childAspectRatio: widget.bookingGridChildAspectRatio ?? 1.7,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(() => CommonButton(
                text: widget.bookingButtonText ?? 'BOOK',
                onTap: () async {
                  controller.toggleUploading();
                  await widget.uploadBooking!(
                      bookings:
                          controller.generateNewBookingDateForUploading());
                  controller.toggleUploading();
                  controller.resetSelectedSlots();
                },
                isDisabled: controller.selectedSlots.value.isEmpty,
                buttonActiveColor: widget.bookingButtonColor!,
              )),
        ],
      ),
    );
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
  return DateFormat("hh:mm a").format(dt);
}

class BookingExplanation extends StatelessWidget {
  const BookingExplanation(
      {Key? key,
       this.color,
       this.text,
      this.explanationIconSize})
      : super(key: key);

  final Color? color;
  final String? text;
  final double? explanationIconSize;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      children: [
        Container(
          height: explanationIconSize ?? 16,
          width: explanationIconSize ?? 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text!,
            style: themeData.textTheme.bodyText1
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
