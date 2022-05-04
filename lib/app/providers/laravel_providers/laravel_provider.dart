import 'dart:io';
import 'package:get/get.dart';
import 'package:home_services/app/models/timeslot_model.dart';
import 'package:home_services/app/providers/firebase_provider.dart';
import 'package:home_services/app/services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../models/e_provider_type_model.dart';
import '../../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider/models/e_provider_plus_model.dart';
import '../../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider/models/tax_plus_model.dart';
import '../../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider_hours/models/availability_hour_model.dart';
import '../../../common/ui.dart';
import '../../models/e_provider_type_model.dart';
import '../../routes/app_routes.dart';
import '../../../common/api_exception.dart';
import '../../models/option_model.dart';
import '../../models/statistic.dart';
import '../../services/settings_service.dart';
import '../../../common/uuid.dart';

import '../../models/address_model.dart';
import '../../models/award_model.dart';
import '../../models/booking_model.dart';
import '../../models/booking_status_model.dart';
import '../../models/category_model.dart';
import '../../models/coupon_model.dart';
import '../../models/custom_page_model.dart';
import '../../models/e_provider_model.dart';
import '../../models/e_service_model.dart';
import '../../models/experience_model.dart';
import '../../models/faq_category_model.dart';
import '../../models/faq_model.dart';
import '../../models/favorite_model.dart';
import '../../models/gallery_model.dart';
import '../../models/notification_model.dart';
import '../../models/option_group_model.dart';
import '../../models/payment_method_model.dart';
import '../../models/payment_model.dart';
import '../../models/review_model.dart';
import '../../models/setting_model.dart';
import '../../models/slide_model.dart';
import '../../models/user_model.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_transaction_model.dart';
import '../api_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';

part 'customer_laravel_provider.dart';
part 'provider_laravel_provider.dart';

abstract class LaravelApiClient extends GetxService {
  Future<LaravelApiClient> init();

  void forceRefresh({Duration duration = const Duration(minutes: 10)});

  void unForceRefresh({Duration duration = const Duration(minutes: 10)});

  Future<List<Slide>> getHomeSlider();

  Future<User> getUser(User user);

  Future<User> login(User user);
  Future<User> register(User user);

  Future<bool> sendResetLinkEmail(User user);

  Future<User> updateUser(User user);
  Future<List<Address>> getAddresses();

  Future<bool> deleteOption(String optionId);

  Future<Option> updateOption(Option option);

  Future<Option> createOption(Option option);

  Future<List<OptionGroup>> getOptionGroups();

  Future<EService> createEService(EService eService);

  Future<EService> updateEService(EService eService);

  Future<List<EProvider>> getEProviders();

  Future<bool> deleteEService(String eServiceId);

  Future<List<Statistic>> getHomeStatistics();

  Future<List<EService>> getRecommendedEServices();

  Future<List<EService>> getAllEServicesWithPagination(
      String categoryId, int page);

  Future<List<EService>> searchEServices(
      String keywords, List<String> categories, int page);

  Future<List<Favorite>> getFavoritesEServices();

  Future<Favorite> addFavoriteEService(Favorite favorite);

  Future<bool> removeFavoriteEService(Favorite favorite);

  Future<EService> getEService(String id);
  Future<EProvider> getEProvider(String eProviderId);

  Future<Review> getEProviderReview(String reviewId);
  Future<List<Review>> getEProviderReviews(String eProviderId);

  Future<List<Gallery>> getEProviderGalleries(String eProviderId);

  Future<List<Award>> getEProviderAwards(String eProviderId);

  Future<List<Experience>> getEProviderExperiences(String eProviderId);

  Future<List<EService>> getEProviderFeaturedEServices(
      String eProviderId, int page);

  Future<List<EService>> getEProviderPopularEServices(
      String eProviderId, int page);

  Future<List<EService>> getEProviderAvailableEServices(
      String eProviderId, int page);

  Future<List<EService>> getEProviderMostRatedEServices(
      String eProviderId, int page);

  Future<List<User>> getEProviderEmployees(String eProviderId);

  Future<List<EService>> getEProviderEServices(String eProviderId, int page);

  Future<List<Review>> getEServiceReviews(String eServiceId);

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId);

  Future<List<EService>> getFeaturedEServices(String categoryId, int page);

  Future<List<EService>> getPopularEServices(String categoryId, int page);

  Future<List<EService>> getMostRatedEServices(String categoryId, int page);

  Future<List<EService>> getAvailableEServices(String categoryId, int page);

  Future<List<Category>> getAllCategories();

  Future<List<Category>> getAllParentCategories();

  Future<List<Category>> getSubCategories(String categoryId);

  Future<List<Category>> getAllWithSubCategories();

  Future<List<Category>> getFeaturedCategories();

  Future<List<Booking>> getBookings(String statusId, int page);

  Future<List<BookingStatus>> getBookingStatuses();

  Future<Booking> getBooking(String bookingId);

  Future<Coupon> validateCoupon(Booking booking);

  Future<Booking> updateBooking(Booking booking);

  Future<Booking> addBooking(Booking booking);

  Future<Review> addReview(Review review);

  Future<List<PaymentMethod>> getPaymentMethods();

  Future<List<Wallet>> getWallets();

  Future<Wallet> createWallet(Wallet _wallet);

  Future<Wallet> updateWallet(Wallet _wallet);

  Future<bool> deleteWallet(Wallet _wallet);

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet);

  Future<Payment> createPayment(Booking _booking);

  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet);

  String getPayPalUrl(Booking _booking);

  String getRazorPayUrl(Booking _booking);

  String getStripeUrl(Booking _booking);

  String getPayStackUrl(Booking _booking);

  String getFlutterWaveUrl(Booking _booking);

  String getStripeFPXUrl(Booking _booking);

  Future<List<Notification>> getNotifications();

  Future<Payment> updatePayment(Payment payment);

  Future<Notification> markAsReadNotification(Notification notification);

  Future<bool> sendNotification(
      List<User> users, User from, String type, String text);

  Future<Notification> removeNotification(Notification notification);

  Future<int> getNotificationsCount();

  Future<List<FaqCategory>> getFaqCategories();

  Future<List<Faq>> getFaqs(String categoryId);

  Future<Setting> getSettings();

  Future<List<CustomPage>> getCustomPages();

  Future<CustomPage> getCustomPageById(String id);
  Future<String>? uploadImage(File file, String field);
  Future<bool> deleteUploaded(String uuid);
  Future<bool> deleteAllUploaded(List<String> uuids);

  Future<Address> createEAddress(Address eAddress);
  Future<EProviderPlus> createEProvider(EProviderPlus eEProvider);
  Future<List<EProviderType>> getEProviderTypes();
  Future<List<Address>> getProviderAddress();
  Future<List<TaxPlus>> getEProviderTaxes();
  Future<List<TaxPlus>> getAllTaxes();

  Future<TimeslotModel> getTimeSlots(String eProviderId,String date);
  Future<TimeslotModel> createTimeslot(TimeslotModel model);
  Future<TimeslotModel> updateTimeslot(TimeslotModel model);
  Future<ProviderAvailabilityHour> createEHours(ProviderAvailabilityHour eHours);

}
