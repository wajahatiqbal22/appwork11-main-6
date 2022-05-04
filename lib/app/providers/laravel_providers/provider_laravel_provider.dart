part of 'laravel_provider.dart';

class ProviderApiClient extends LaravelApiClient with ApiClient {
  late dio.Dio _httpClient;
  dio.Options? _optionsNetwork;
  dio.Options? _optionsCache;

  ProviderApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl!;
    _httpClient = new dio.Dio();
  }

  Future<ProviderApiClient> init() async {
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

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/user")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(
        _uri,
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
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

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("provider/login");
    printUri(StackTrace.current, _uri);
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

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("provider/register");
    printUri(StackTrace.current, _uri);
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
          print('Ee');
          throw new ApiException('An error occurred');
        }
      } else {
        print('Ee');
        throw new ApiException('An error occured');
      }
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("provider/send_reset_link_email");
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
    Uri _uri = getApiBaseUri("provider/users/${user.id}")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
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

  Future<List<Statistic>> getHomeStatistics() async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getHomeStatistics() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/dashboard")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Statistic>((obj) => Statistic.fromJson(obj))
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
  Future<ProviderAvailabilityHour> createEHours(ProviderAvailabilityHour eHours) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createEHours(EAddress eHours) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_provider_hours").replace(queryParameters: _queryParameters);

    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eHours.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return ProviderAvailabilityHour.fromJson(response.data['data']);
      } else {
        print("success:${response.data['message']}");
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
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
    };
    print(_queryParameters);
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      print("response:${response.data}");
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Address>((obj) => Address.fromJson(obj))
            //.skip(0)
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
    // TODO Pagination
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
      'with': 'eProvider;categories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
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

  Future<EService> createEService(EService eService) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ createEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eService.toJson()),
        options: _optionsNetwork,
      );
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

  Future<EService> updateEService(EService eService) async {
    if (!authService.isAuth || !eService.hasData) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ updateEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eService.id}")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.patchUri(
        _uri,
        data: json.encode(eService.toJson()),
        options: _optionsNetwork,
      );
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

  Future<bool> deleteEService(String eServiceId) async {
    if (!authService.isAuth || eServiceId == null) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ deleteEService(String eServiceId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eServiceId}")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.deleteUri(
        _uri,
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

  Future<Option> createOption(Option option) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ createOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("options").replace(queryParameters: _queryParameters);
    print(option.toJson());
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(option.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return Option.fromJson(response.data['data']);
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

  Future<Option> updateOption(Option option) async {
    if (!authService.isAuth || !option.hasData) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ updateOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${option.id}")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print(option.toJson());
    try {
      var response = await _httpClient.patchUri(
        _uri,
        data: json.encode(option.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return Option.fromJson(response.data['data']);
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

  Future<bool> deleteOption(String optionId) async {
    if (!authService.isAuth || optionId == null) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ deleteOption(String optionId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${optionId}")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.deleteUri(
        _uri,
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

  Future<EProvider> getEProvider(String eProviderId) async {
    const _queryParameters = {
      'with': 'eProviderType;availabilityHours;users',
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.statusCode == 200) {
        return EProvider.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.statusMessage!);
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

  Future<List<EProvider>> getEProviders() async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getEProviders() ]");
    }
    var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/e_providers")
        .replace(queryParameters: _queryParameters);
//    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      print(response);
      if (response.data['success'] == true) {
        return response.data['data']
            .map<EProvider>((obj) => EProvider.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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

  Future<List<Review>> getEProviderReviews(String userId) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ getEProviderReviews() ]");
    }
    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService;created_at',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      // 'limit': '10',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/e_service_reviews")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<Review>((obj) => Review.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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

  Future<Review> getEProviderReview(String reviewId) async {
    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService',
    };
    Uri _uri = getApiBaseUri("e_service_reviews/$reviewId")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return Review.fromJson(response.data['data']);
      } else {
        throw new ApiException(response.statusMessage!);
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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
      String s, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
      String s, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
      String s, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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

  Future<List<EService>> getEProviderMostRatedEServices(String s, page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
        throw new ApiException(response.data['message']);
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

  Future<List<EService>> getEProviderEServices(String s, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
      'limit': '10',
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<Review>((obj) => Review.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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

  Future<List<OptionGroup>> getOptionGroups() async {
    var _queryParameters = {
      'with': 'options',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsCache);
      if (response.statusCode == 200) {
        return response.data['data']
            .map<Category>((obj) => Category.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.statusMessage!);
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
    print("error 1");
    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    print("error 2");
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      print("error 3");
      if (response.data['success'] == true) {
        return response.data['data']
            .map<Booking>((obj) => Booking.fromJson(obj))
            .toList();
      } else {
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      print("error 5");
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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

  Future<Payment> updatePayment(Payment payment) async {
    if (!authService.isAuth) {
      throw new ApiException(
          "You don't have the permission to access to this area!".tr +
              "[ updatePayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/payments/${payment.id}")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.putUri(_uri,
          data: payment.toJson(), options: _optionsNetwork);
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

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new ApiException(
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
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
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
      print(e);
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
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.patchUri(_uri,
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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
    Uri _uri = getApiBaseUri("provider/settings");
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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
    printUri(StackTrace.current, _uri);
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

  // Future<String> uploadImage(File file, String field) async {
  //   if (!authService.isAuth) {
  //     throw new Exception(
  //         "You don't have the permission to access to this area!".tr +
  //             "[ uploadImage() ]");
  //   }
  //   String fileName = file.path.split('/').last;
  //   var _queryParameters = {
  //     'api_token': authService.apiToken,
  //   };
  //   Uri _uri = getApiBaseUri("uploads/store")
  //       .replace(queryParameters: _queryParameters);
  //   printUri(StackTrace.current, _uri);
  //   dio.FormData formData = dio.FormData.fromMap({
  //     "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
  //     "uuid": Uuid().generateV4(),
  //     "field": field,
  //   });
  //   var response = await _httpClient.postUri(_uri, data: formData);
  //   Get.showSnackbar(Ui.SuccessSnackBar(message: response.data['message'].toString()));
  //   print(response.data);
  //   if (response.data['data'] != false) {
  //     return response.data['data'];
  //   } else {
  //
  //     if(response.data['message'].toString().contains("[403]")){
  //       Get.showSnackbar(Ui.ErrorSnackBar(message: "Image size exceeded the 2mb limit."));
  //     }else{
  //       throw Get.showSnackbar(Ui.ErrorSnackBar(message: response.data['message'].toString()));
  //     }
  //     //throw
  //     //throw new Exception(response.data['message']);
  //   }
  // }

  Future<String>? uploadImage(File file, String field) async {
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
      Get.showSnackbar(Ui.SuccessSnackBar(message: response.data['message'].toString()));
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
        //throw new ApiException('An error occured');
        if(e.toString().contains("[403]")){
          Get.showSnackbar(Ui.ErrorSnackBar(message: "Image size exceeded the 2mb limit."));
        }else{
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        }
        throw new ApiException('An error occurred');
      }
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
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
      var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
      Get.showSnackbar(Ui.SuccessSnackBar(message: response.data['message'].toString()));
      print(response.data);
      if (response.data['data'] != false) {
        return true;
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: response.data['message'].toString()));
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
          throw new ApiException('An error occurred');
        }
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
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
      Get.showSnackbar(Ui.SuccessSnackBar(message: response.data['message'].toString()));
      print(response.data);
      if (response.data['data'] != false) {
        return true;
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: response.data['message'].toString()));
        throw new ApiException(response.data['message'].toString());
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.other) {
        if (e.error.toString().contains('SocketException')) {
          throw new ApiException('No Internet connection');
        } else {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
          throw new ApiException('An error occurred');
        }
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        throw new ApiException('An error occured');
      }
    }
  }

  @override
  Future<Booking> addBooking(Booking booking) {
    // TODO: implement addBooking
    throw UnimplementedError();
  }

  @override
  Future<Favorite> addFavoriteEService(Favorite favorite) {
    // TODO: implement addFavoriteEService
    throw UnimplementedError();
  }

  @override
  Future<Review> addReview(Review review) {
    // TODO: implement addReview
    throw UnimplementedError();
  }

  @override
  Future<Payment> createPayment(Booking _booking) {
    // TODO: implement createPayment
    throw UnimplementedError();
  }

  @override
  Future<Wallet> createWallet(Wallet _wallet) {
    // TODO: implement createWallet
    throw UnimplementedError();
  }

  @override
  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet) {
    // TODO: implement createWalletPayment
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWallet(Wallet _wallet) {
    // TODO: implement deleteWallet
    throw UnimplementedError();
  }

  @override
  Future<List<EService>> getAllEServicesWithPagination(
      String categoryId, int page) {
    // TODO: implement getAllEServicesWithPagination
    throw UnimplementedError();
  }

  @override
  Future<List<EService>> getAvailableEServices(String categoryId, int page) {
    // TODO: implement getAvailableEServices
    throw UnimplementedError();
  }

  @override
  Future<List<Gallery>> getEProviderGalleries(String eProviderId) {
    // TODO: implement getEProviderGalleries
    throw UnimplementedError();
  }

  @override
  Future<List<Favorite>> getFavoritesEServices() {
    // TODO: implement getFavoritesEServices
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> getFeaturedCategories() {
    // TODO: implement getFeaturedCategories
    throw UnimplementedError();
  }

  @override
  Future<List<EService>> getFeaturedEServices(String categoryId, int page) {
    // TODO: implement getFeaturedEServices
    throw UnimplementedError();
  }

  @override
  String getFlutterWaveUrl(Booking _booking) {
    // TODO: implement getFlutterWaveUrl
    throw UnimplementedError();
  }

  @override
  Future<List<Slide>> getHomeSlider() {
    // TODO: implement getHomeSlider
    throw UnimplementedError();
  }

  @override
  Future<List<EService>> getMostRatedEServices(String categoryId, int page) {
    // TODO: implement getMostRatedEServices
    throw UnimplementedError();
  }

  @override
  String getPayPalUrl(Booking _booking) {
    // TODO: implement getPayPalUrl
    throw UnimplementedError();
  }

  @override
  String getPayStackUrl(Booking _booking) {
    // TODO: implement getPayStackUrl
    throw UnimplementedError();
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() {
    // TODO: implement getPaymentMethods
    throw UnimplementedError();
  }

  @override
  Future<List<EService>> getPopularEServices(String categoryId, int page) {
    // TODO: implement getPopularEServices
    throw UnimplementedError();
  }

  @override
  String getRazorPayUrl(Booking _booking) {
    // TODO: implement getRazorPayUrl
    throw UnimplementedError();
  }

  @override
  Future<List<EService>> getRecommendedEServices() {
    // TODO: implement getRecommendedEServices
    throw UnimplementedError();
  }

  @override
  String getStripeFPXUrl(Booking _booking) {
    // TODO: implement getStripeFPXUrl
    throw UnimplementedError();
  }

  @override
  String getStripeUrl(Booking _booking) {
    // TODO: implement getStripeUrl
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> getSubCategories(String categoryId) {
    // TODO: implement getSubCategories
    throw UnimplementedError();
  }

  @override
  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    // TODO: implement getWalletTransactions
    throw UnimplementedError();
  }

  @override
  Future<List<Wallet>> getWallets() {
    // TODO: implement getWallets
    throw UnimplementedError();
  }

  @override
  Future<bool> removeFavoriteEService(Favorite favorite) {
    // TODO: implement removeFavoriteEService
    throw UnimplementedError();
  }

  @override
  Future<Wallet> updateWallet(Wallet _wallet) {
    // TODO: implement updateWallet
    throw UnimplementedError();
  }

  @override
  Future<Coupon> validateCoupon(Booking booking) {
    // TODO: implement validateCoupon
    throw UnimplementedError();
  }

  Future<Address> createEAddress(Address eAddress) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createEAddress(EAddress eAddress) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_address").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eAddress.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        Get.toNamed(Routes.E_PROVIDER_PLUS_CREATE);
        return Address.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  /*Future<ProviderAvailabilityHour> createEHours(ProviderAvailabilityHour eHours) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createEHours(EAddress eHours) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_provider_hours").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eHours.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return ProviderAvailabilityHour.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }*/

  Future<EProviderPlus> createEProvider(EProviderPlus eEProvider) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createEProvider(EProvider eProvider) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_provider_plus").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eEProvider.toJson()),
        options: _optionsNetwork,
      );
      print("e provider plus resp:${response.data}");
      if (response.data['success'] == true) {
        return EProviderPlus.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<List<EProviderType>> getEProviderTypes() async {
    var _queryParameters = {
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("e_provider_types").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EProviderType>((obj) => EProviderType.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }



  Future<List<TaxPlus>> getEProviderTaxes() async {
    var _queryParameters = {
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("e_provider_taxes").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<TaxPlus>((obj) => TaxPlus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<TaxPlus>> getAllTaxes() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getEProviders() ]");
    }
    var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_provider_taxes").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<TaxPlus>((obj) => TaxPlus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  @override
  Future<TimeslotModel> createTimeslot(TimeslotModel model) async {
    /*if (authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createEProvider(EProvider eProvider) ]");
    }*/

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
/*
    var _queryParameters = {
      'orderBy': 'description',
      'sortBy': 'desc',
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:='
    };
*/

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
