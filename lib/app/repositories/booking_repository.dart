import 'package:get/get.dart';
import 'package:home_services/app/models/timeslot_model.dart';
import 'package:home_services/common/api_exception.dart';
import '../providers/laravel_providers/laravel_provider.dart';

import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/coupon_model.dart';
import '../models/review_model.dart';

class BookingRepository {
  late LaravelApiClient _laravelApiClient;

  BookingRepository(LaravelApiClient client) {
    this._laravelApiClient = client; //Get.find<LaravelApiClient>();
  }

  Future<List<Booking>> all(String statusId, {int? page}) {
    try {
      return _laravelApiClient.getBookings(statusId, page!);
    } on ApiException catch (e) {
      print("error unknown");
      throw e.message;
    }
  }

  Future<List<BookingStatus>> getStatuses() {
    try {
      return _laravelApiClient.getBookingStatuses();
    } on ApiException catch (e) {
      print("error is here");
      throw e.message;
    }
  }

  Future<Booking> get(String bookingId) {
    try {
      return _laravelApiClient.getBooking(bookingId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Booking> add(Booking booking) {
    try {
      return _laravelApiClient.addBooking(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Booking> update(Booking booking) {
    try {
      return _laravelApiClient.updateBooking(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Coupon> coupon(Booking booking) {
    try {
      return _laravelApiClient.validateCoupon(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

/*
  Future<TimeslotModel> getTimeSlots(String eProviderId, String date) {
    try {
      return _laravelApiClient.getTimeSlots(eProviderId, date);
    }on ApiException catch (e) {
      throw e.message;
    }
  }*/

  Future<TimeslotModel> getTimeSlots(String eProviderId, String date) {
    return _laravelApiClient.getTimeSlots(eProviderId, date);
  }
  Future<TimeslotModel> createTimeslot(TimeslotModel model) {
    try {
      return _laravelApiClient.createTimeslot(model);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<TimeslotModel> updateTimeslot(TimeslotModel model) {
    try {
      return _laravelApiClient.updateTimeslot(model);
    } on ApiException catch (e) {
      throw e.message;
    }
  }


  Future<Review> addReview(Review review) {
    try {
      return _laravelApiClient.addReview(review);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
