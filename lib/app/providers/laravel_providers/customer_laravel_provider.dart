part of 'laravel_provider.dart';

class CustomerApiClient extends LaravelApiClient with ApiClient {
  late dio.Dio _httpClient;
  dio.Options? _optionsNetwork;
  dio.Options? _optionsCache;

  CustomerApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl!;
    _httpClient = new dio.Dio();
  }

  Future<CustomerApiClient> init() async {
    if (foundation.kIsWeb || foundation.kDebugMode) {
      _optionsNetwork = dio.Options();
      _optionsCache = dio.Options();
    } else {
      _optionsNetwork =
          buildCacheOptions(Duration(days: 3), forceRefresh: true);
      _optionsCache =
          buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
      _httpClient.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    }
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = dio.Options();
    }
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    Uri _uri = getApiBaseUri("slides");
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Slide>((obj) => Slide.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(
        _uri,
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      } else {
        throw ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("login");
    Get.log(_uri.toString());
    Get.log(user.toJson().toString());
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(user.toJson()),
        options: _optionsNetwork,
      );
      Get.log(response.data.toString());
      if (response.data['success'] == true) {
        response.data['data']['auth'] = true;
        return User.fromJson(response.data['data']);
      } else {
        throw ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("register");
    Get.log(_uri.toString());
    Get.log(json.encode(user.toJson()));
    try {
      var response = await _httpClient.postUri(_uri,
          data: json.encode(user.toJson()), options: _optionsNetwork);
      Get.log(response.data.toString());
      if (response.data['success'] == true) {
        response.data['data']['auth'] = true;
        return User.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        Get.log(e.response.toString());
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("send_reset_link_email");
    Get.log(_uri.toString());
    // to remove other attributes from the user object
    user = new User(email: user.email);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(user.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return true;
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("users/${user.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(user.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        response.data['data']['auth'] = true;
        return User.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'orderBy': 'id',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Address>((obj) => Address.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getRecommendedEServices() async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      'only':
          'id;name;price;discount_price;price_unit;has_media;media;total_reviews;rate',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getAllEServicesWithPagination(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> searchEServices(
      String keywords, List<String> categories, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Favorite>> getFavoritesEServices() async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getFavoritesEServices() ]");
    }
    var _queryParameters = {
      'with': 'eService;options;eService.eProvider',
      'search': 'user_id:${authService.user.value.id}',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Favorite>((obj) => Favorite.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Favorite> addFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You must have an account to be able to add services to favorite".tr +
              "[ addFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(favorite.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        response.data['data']['auth'] = true;
        return Favorite.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> removeFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You must have an account to be able to add services to favorite".tr +
              "[ removeFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites/1").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.deleteUri(
        _uri,
        data: json.encode(favorite.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;categories;eProvider.taxes',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return EService.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<EProvider> getEProvider(String eProviderId) async {
    const _queryParameters = {
      'with': 'eProviderType;availabilityHours;users',
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return EProvider.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Review>> getEProviderReviews(String eProviderId) async {
    var _queryParameters = {
      'with': 'eProviderReviews;eProviderReviews.user',
      'only':
          'eProviderReviews.id;eProviderReviews.review;eProviderReviews.rate;eProviderReviews.user;'
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']['e_provider_reviews']
            .map<Review>((obj) => Review.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Gallery>> getEProviderGalleries(String eProviderId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("galleries").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Gallery>((obj) => Gallery.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Award>> getEProviderAwards(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Award>((obj) => Award.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Experience>> getEProviderExperiences(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Experience>((obj) => Experience.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId;featured:1',
      'searchFields': 'e_provider_id:=;featured:=',
      'searchJoin': 'and',
      'limit': '5',
      'offset': ((page - 1) * 5).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getEProviderPopularEServices(
      String eProviderId, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<User>> getEProviderEmployees(String eProviderId) async {
    var _queryParameters = {
      'with': 'users',
      'only':
          'users;users.id;users.name;users.email;users.phone_number;users.device_token'
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']['users']
            .map<User>((obj) => User.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getEProviderEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {
      'with': 'user',
      'only': 'created_at;review;rate;user',
      'search': "e_service_id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'limit': '10'
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Review>((obj) => Review.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options;options.media',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getFeaturedEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId;featured:1',
      'searchFields': 'categories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getPopularEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getMostRatedEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<EService>> getAvailableEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Category>> getSubCategories(String categoryId) async {
    final _queryParameters = {
      'search': "parent_id:$categoryId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredEServices',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Booking>> getBookings(String statusId, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      // 'search': 'user_id:${authService.user.value.id}',
      'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Booking>((obj) => Booking.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("booking_statuses")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<BookingStatus>((obj) => BookingStatus.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with':
          'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Coupon> validateCoupon(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': booking.coupon?.code ?? '',
      'e_service_id': booking.eService?.id ?? '',
      'e_provider_id': booking.eService?.eProvider?.id ?? '',
      'categories_id':
          booking.eService?.categories?.map((e) => e.id)?.join(",") ?? '',
    };
    Uri _uri =
        getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Coupon.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.putUri(_uri,
          data: booking.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Booking> addBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(_uri,
          data: booking.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        Get.log(e.response.toString());
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Review> addReview(Review review) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(_uri,
          data: review.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Review.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Wallet>((obj) => Wallet.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(_uri,
          data: _wallet.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Wallet.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.putUri(_uri,
          data: _wallet.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Wallet.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response =
          await _httpClient.deleteUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/cash")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(_uri,
          data: _booking.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Payment.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.postUri(_uri,
          data: _booking.toJson(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Payment.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  String getPayPalUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paypal/express-checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/razorpay/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/stripe/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paystack/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/flutterwave/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/stripe-fpx/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw  ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
//      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    print(_queryParameters);
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Notification>((obj) => Notification.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e is dio.DioError) {
        print("its dio error:${e.response}");
      }
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.putUri(_uri,
          data: notification.markReadMap(), options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Notification.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> sendNotification(
      List<User> users, User from, String type, String text) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    try {
      var response =
          await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return true;
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        Get.log(e.response.toString());
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response =
          await _httpClient.deleteUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Notification.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<FaqCategory>((obj) => FaqCategory.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Faq>((obj) => Faq.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("settings");
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.data['success'] == true) {
        return Setting.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<CustomPage>((obj) => CustomPage.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    Get.log(_uri.toString());
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return CustomPage.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/store")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    try {
      var response = await _httpClient.postUri(_uri, data: formData);
      print(response.data);
      if (response.data['data'] != false) {
        return response.data['data'];
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
      print(response.data);
      if (response.data['data'] != false) {
        return true;
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
      print(response.data);
      if (response.data['data'] != false) {
        return true;
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          throw new ApiException('An error occurred');
        }
      } else {
        throw new ApiException('An error occured');
      }
    }
  }

  @override
  Future<List<Statistic>> getHomeStatistics() {
    // TODO: implement getHomeStatistics
    throw UnimplementedError();
  }

  @override
  Future<Payment> updatePayment(Payment payment) {
    // TODO: implement updatePayment
    throw UnimplementedError();
  }

  @override
  Future<Review> getEProviderReview(String reviewId) {
    // TODO: implement getEProviderReview
    throw UnimplementedError();
  }

  @override
  Future<EService> createEService(EService eService) {
    // TODO: implement createEService
    throw UnimplementedError();
  }

  @override
  Future<Option> createOption(Option option) {
    // TODO: implement createOption
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteEService(String eServiceId) {
    // TODO: implement deleteEService
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteOption(String optionId) {
    // TODO: implement deleteOption
    throw UnimplementedError();
  }

  @override
  Future<List<OptionGroup>> getOptionGroups() {
    // TODO: implement getOptionGroups
    throw UnimplementedError();
  }

  @override
  Future<EService> updateEService(EService eService) {
    // TODO: implement updateEService
    throw UnimplementedError();
  }

  @override
  Future<Option> updateOption(Option option) {
    // TODO: implement updateOption
    throw UnimplementedError();
  }

  @override
  Future<List<EProvider>> getEProviders() {
    // TODO: implement getEProviders
    throw UnimplementedError();
  }

  @override
  Future<Address> createEAddress(Address eAddress) {
    // TODO: implement createEAddress
    throw UnimplementedError();
  }

  @override
  Future<EProviderPlus> createEProvider(EProviderPlus eEProvider) {
    // TODO: implement createEProvider
    throw UnimplementedError();
  }

  @override
  Future<List<TaxPlus>> getAllTaxes() {
    // TODO: implement getAllTaxes
    throw UnimplementedError();
  }

  @override
  Future<List<TaxPlus>> getEProviderTaxes() {
    // TODO: implement getEProviderTaxes
    throw UnimplementedError();
  }

  @override
  Future<List<EProviderType>> getEProviderTypes() {
    // TODO: implement getEProviderTypes
    throw UnimplementedError();
  }

  @override
  Future<ProviderAvailabilityHour> createEHours(ProviderAvailabilityHour eHours) {
    // TODO: implement createEHours
    throw UnimplementedError();
  }

  @override
  Future<TimeslotModel> createTimeslot(TimeslotModel model) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createEProvider(EProvider eProvider) ]");
    }

    Uri _uri = getApiBaseUri("timeslots");
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(model.toJson()),
        options: _optionsNetwork,
      );
      if (response.statusCode == 200) {
        return TimeslotModel.fromJson(response.data);
      } else {
        throw new Exception(response.statusMessage);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<TimeslotModel> getTimeSlots(String eProviderId, String date) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getUser() ]");
    }
    var _queryParameters = {
      'e_provider_id': eProviderId,
      'date': date,
    };
    Uri _uri =
        getApiBaseUri("timeslots").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(
        _uri,
        options: _optionsNetwork,
      );
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data is List) {
          throw ('No slots available');
        }
        return TimeslotModel.fromJson(response.data);
      } else {
        throw new Exception(response.statusMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TimeslotModel> updateTimeslot(TimeslotModel model) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createEProvider(EProvider eProvider) ]");
    }

    Uri _uri = getApiBaseUri("update-timeslots");
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.putUri(
        _uri,
        data: json.encode(model.toJson()),
        options: _optionsNetwork,
      );
      if (response.statusCode == 200) {
        return TimeslotModel.fromJson(response.data);
      } else {
        throw new Exception(response.statusMessage);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<List<Address>> getProviderAddress() {
    // TODO: implement getProviderAddress
    throw UnimplementedError();
  }
}
