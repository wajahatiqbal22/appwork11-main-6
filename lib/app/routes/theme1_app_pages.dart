import 'package:get/get.dart' show GetPage, Transition;
import 'package:home_services/app/modules/customer_modules/book_e_service/views/time_slot_picker.dart';
import 'package:home_services/app/modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider_hours/bindings/e_hours_binding.dart';
import 'package:home_services/app/modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider_hours/views/e_hour_form_view.dart';
import 'package:home_services/app/modules/provider_modules/availability/bindings/availability_binding.dart';
import 'package:home_services/app/modules/provider_modules/availability/views/availability_view.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider_hours/views/e_hour_form_view_new.dart';
import '../modules/provider_modules/auth/bindings/auth_binding.dart';
import '../modules/provider_modules/auth/views/forgot_password_view.dart';
import '../modules/provider_modules/auth/views/login_view.dart';
import '../modules/provider_modules/auth/views/phone_verification_view.dart';
import '../modules/provider_modules/auth/views/register_view.dart';
import '../modules/provider_modules/bookings/views/booking_view.dart';
import '../modules/provider_modules/custom_pages/bindings/custom_pages_binding.dart';
import '../modules/provider_modules/custom_pages/views/custom_pages_view.dart';
import '../modules/provider_modules/e_services/bindings/e_services_binding.dart';
import '../modules/provider_modules/e_services/views/e_service_form_view.dart';
import '../modules/provider_modules/e_services/views/e_service_view.dart';
import '../modules/provider_modules/e_services/views/e_services_view.dart';
import '../modules/provider_modules/e_services/views/options_form_view.dart';
import '../modules/provider_modules/gallery/bindings/gallery_binding.dart';
import '../modules/provider_modules/gallery/views/gallery_view.dart';
import '../modules/provider_modules/help_privacy/bindings/help_privacy_binding.dart';
import '../modules/provider_modules/help_privacy/views/help_view.dart';
import '../modules/provider_modules/help_privacy/views/privacy_view.dart';
import '../modules/provider_modules/messages/views/chats_view.dart';
import '../modules/provider_modules/notifications/bindings/notifications_binding.dart';
import '../modules/provider_modules/notifications/views/notifications_view.dart';
import '../modules/provider_modules/profile/bindings/profile_binding.dart';
import '../modules/provider_modules/profile/views/profile_view.dart';
import '../modules/provider_modules/reviews/views/review_view.dart';
import '../modules/provider_modules/root/bindings/root_binding.dart';
import '../modules/provider_modules/root/views/root_view.dart';
import '../modules/provider_modules/search/views/search_view.dart';
import '../modules/provider_modules/settings/bindings/settings_binding.dart';
import '../modules/provider_modules/settings/views/language_view.dart';
import '../modules/provider_modules/settings/views/settings_view.dart';
import '../modules/provider_modules/settings/views/theme_mode_view.dart';

import '../middlewares/auth_middleware.dart';
import '../modules/customer_modules/auth/bindings/auth_binding.dart';
import '../modules/customer_modules/auth/views/forgot_password_view.dart';
import '../modules/customer_modules/auth/views/login_view.dart';
import '../modules/customer_modules/auth/views/phone_verification_view.dart';
import '../modules/customer_modules/auth/views/register_view.dart';
import '../modules/customer_modules/book_e_service/bindings/book_e_service_binding.dart';
import '../modules/customer_modules/book_e_service/views/book_e_service_view.dart';
import '../modules/customer_modules/book_e_service/views/booking_summary_view.dart';
import '../modules/customer_modules/bookings/views/booking_view.dart';
import '../modules/customer_modules/category/bindings/category_binding.dart';
import '../modules/customer_modules/category/views/categories_view.dart';
import '../modules/customer_modules/category/views/category_view.dart';
import '../modules/customer_modules/checkout/bindings/checkout_binding.dart';
import '../modules/customer_modules/checkout/views/cash_view.dart';
import '../modules/customer_modules/checkout/views/checkout_view.dart';
import '../modules/customer_modules/checkout/views/confirmation_view.dart';
import '../modules/customer_modules/checkout/views/flutterwave_view.dart';
import '../modules/customer_modules/checkout/views/paypal_view.dart';
import '../modules/customer_modules/checkout/views/paystack_view.dart';
import '../modules/customer_modules/checkout/views/razorpay_view.dart';
import '../modules/customer_modules/checkout/views/stripe_fpx_view.dart';
import '../modules/customer_modules/checkout/views/stripe_view.dart';
import '../modules/customer_modules/checkout/views/wallet_view.dart';
import '../modules/customer_modules/custom_pages/bindings/custom_pages_binding.dart';
import '../modules/customer_modules/custom_pages/views/custom_pages_view.dart';
import '../modules/customer_modules/e_provider/bindings/e_provider_binding.dart';
import '../modules/customer_modules/e_provider/views/e_provider_e_services_view.dart';
import '../modules/customer_modules/e_provider/views/e_provider_view.dart';
import '../modules/customer_modules/e_service/bindings/e_service_binding.dart';
import '../modules/customer_modules/e_service/views/e_service_view.dart';
import '../modules/customer_modules/favorites/bindings/favorites_binding.dart';
import '../modules/customer_modules/favorites/views/favorites_view.dart';
import '../modules/customer_modules/gallery/bindings/gallery_binding.dart';
import '../modules/customer_modules/gallery/views/gallery_view.dart';
import '../modules/customer_modules/help_privacy/bindings/help_privacy_binding.dart';
import '../modules/customer_modules/help_privacy/views/help_view.dart';
import '../modules/customer_modules/help_privacy/views/privacy_view.dart';
import '../modules/customer_modules/messages/views/chats_view.dart';
import '../modules/customer_modules/notifications/bindings/notifications_binding.dart';
import '../modules/customer_modules/notifications/views/notifications_view.dart';
import '../modules/customer_modules/profile/bindings/profile_binding.dart';
import '../modules/customer_modules/profile/views/profile_view.dart';
import '../modules/customer_modules/rating/bindings/rating_binding.dart';
import '../modules/customer_modules/rating/views/rating_view.dart';
import '../modules/customer_modules/root/bindings/root_binding.dart';
import '../modules/customer_modules/root/views/root_view.dart';
import '../modules/customer_modules/search/views/search_view.dart';
import '../modules/customer_modules/settings/bindings/settings_binding.dart';
import '../modules/customer_modules/settings/views/address_picker_view.dart';
import '../modules/customer_modules/settings/views/addresses_view.dart';
import '../modules/customer_modules/settings/views/language_view.dart';
import '../modules/customer_modules/settings/views/settings_view.dart';
import '../modules/customer_modules/settings/views/theme_mode_view.dart';
import '../modules/customer_modules/wallets/bindings/wallets_binding.dart';
import '../modules/customer_modules/wallets/views/wallet_form_view.dart';
import '../modules/customer_modules/wallets/views/wallets_view.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider/bindings/e_provider_binding.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_address/bindings/e_address_binding.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_address/views/e_address_form_view.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_provider/views/e_provider_form_view.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/providers/global_bindings/e_global_binding.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/providers/global_views/e_provider_plus_success_view.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/providers/global_views/e_provider_plus_welcome_view.dart';
import '../modules/provider_modules/_kriacoes_agency_modules/ProviderPlus/e_address/views/e_address_picker_view.dart';
import 'app_routes.dart';

class Theme1AppPages {
  static const INITIAL = Routes.ROOT;
  static const PINITIAL = Routes.PROOT;

  static final routes = [
    GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.RATING, page: () => RatingView(), binding: RatingBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHAT, page: () => ChatsView(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESSES, page: () => AddressesView(), binding: SettingsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_LANGUAGE, page: () => LanguageView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESS_PICKER, page: () => AddressPickerView()),
    GetPage(name: Routes.PROFILE, page: () => ProfileView(), binding: ProfileBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CATEGORY, page: () => CategoryView(), binding: CategoryBinding()),
    GetPage(name: Routes.CATEGORIES, page: () => CategoriesView(), binding: CategoryBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding()),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding()),
    GetPage(name: Routes.PHONE_VERIFICATION, page: () => PhoneVerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.TIMESLOTS, page: () => TimeSlotPage(), binding: BookEServiceBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.E_SERVICE, page: () => EServiceView(), binding: EServiceBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.BOOK_E_SERVICE, page: () => BookEServiceView(), binding: BookEServiceBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.BOOKING_SUMMARY, page: () => BookingSummaryView(), binding: BookEServiceBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHECKOUT, page: () => CheckoutView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CONFIRMATION, page: () => ConfirmationView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: RootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.NOTIFICATIONS, page: () => NotificationsView(), binding: NotificationsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FAVORITES, page: () => FavoritesView(), binding: FavoritesBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PRIVACY, page: () => PrivacyView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.HELP, page: () => HelpView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.E_PROVIDER, page: () => EProviderView(), binding: EProviderBinding()),
    GetPage(name: Routes.E_PROVIDER_E_SERVICES, page: () => EProviderEServicesView(), binding: EProviderBinding()),
    GetPage(name: Routes.BOOKING, page: () => BookingView(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYPAL, page: () => PayPalViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.RAZORPAY, page: () => RazorPayViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE, page: () => StripeViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE_FPX, page: () => StripeFPXViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYSTACK, page: () => PayStackViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FLUTTERWAVE, page: () => FlutterWaveViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CASH, page: () => CashViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.WALLET, page: () => WalletViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CUSTOM_PAGES, page: () => CustomPagesView(), binding: CustomPagesBinding()),
    GetPage(name: Routes.GALLERY, page: () => GalleryView(), binding: GalleryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.WALLETS, page: () => WalletsView(), binding: WalletsBinding()),
    GetPage(name: Routes.WALLET_FORM, page: () => WalletFormView(), binding: WalletsBinding()),

    /// Provider Routes
     GetPage(name: Routes.PROOT, page: () => PRootView(), binding: PRootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PCHAT, page: () => PChatsView(), binding: PRootBinding()),
    GetPage(name: Routes.PSETTINGS, page: () => PSettingsView(), binding: PSettingsBinding()),
    GetPage(name: Routes.PSETTINGS_THEME_MODE, page: () => PThemeModeView(), binding: PSettingsBinding()),
    GetPage(name: Routes.PSETTINGS_LANGUAGE, page: () => PLanguageView(), binding: PSettingsBinding()),
    GetPage(name: Routes.PPROFILE, page: () => PProfileView(), binding: PProfileBinding()),
    GetPage(name: Routes.PLOGIN, page: () => PLoginView(), binding: PAuthBinding()),
    GetPage(name: Routes.PREGISTER, page: () => PRegisterView(), binding: PAuthBinding()),
    GetPage(name: Routes.PFORGOT_PASSWORD, page: () => PForgotPasswordView(), binding: PAuthBinding()),
    GetPage(name: Routes.PPHONE_VERIFICATION, page: () => PPhoneVerificationView(), binding: PAuthBinding()),
    GetPage(name: Routes.PE_SERVICE, page: () => PEServiceView(), binding: PEServicesBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.PE_SERVICE_FORM, page: () => PEServiceFormView(), binding: PEServicesBinding()),
    GetPage(name: Routes.POPTIONS_FORM, page: () => POptionsFormView(), binding: PEServicesBinding()),
    GetPage(name: Routes.PE_SERVICES, page: () => PEServicesView(), binding: PEServicesBinding()),
    GetPage(name: Routes.PSEARCH, page: () => PSearchView(), binding: PRootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.PNOTIFICATIONS, page: () => PNotificationsView(), binding: PNotificationsBinding()),
    GetPage(name: Routes.PPRIVACY, page: () => PPrivacyView(), binding: PHelpPrivacyBinding()),
    GetPage(name: Routes.PHELP, page: () => PHelpView(), binding: PHelpPrivacyBinding()),
    GetPage(name: Routes.PCUSTOM_PAGES, page: () => PCustomPagesView(), binding: PCustomPagesBinding()),
    GetPage(name: Routes.REVIEW, page: () => ReviewView(), binding: PRootBinding()),
    GetPage(name: Routes.PBOOKING, page: () => PBookingView(), binding: PRootBinding()),
    GetPage(name: Routes.PGALLERY, page: () => PGalleryView(), binding: PGalleryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.E_PROVIDER_PLUS_WELCOME, page: () => EWelcomeView(), binding: EGlobalBinding()),
    GetPage(name: Routes.E_PROVIDER_PLUS_SETTINGS_ADDRESS_PICKER, page: () => AddressPlusPickerView()),
    GetPage(name: Routes.E_PROVIDER_PLUS_ADDRESS_CREATE, page: () => EAddressFormView(), binding: EAddressBinding()),
    GetPage(name: Routes.E_PROVIDER_PLUS_CREATE, page: () => EProviderFormView(), binding: EProviderPlusBinding()),
    GetPage(name: Routes.E_PROVIDER_PLUS_HOURS, page: () => EHoursFormView(), binding: EHoursBinding()),
    GetPage(name: Routes.E_PROVIDER_PLUS_SUCCESS, page: () => ESuccessView(), binding: EGlobalBinding()),
    GetPage(name: Routes.PAVAILABILITY, page: () => AvailabilityPage(), binding: AvailabilityBinding()),
  ];
}
