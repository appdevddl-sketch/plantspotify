# API Integration Architecture Guide

## Folder Structure

```
lib/
├── main.dart
├── model/
│   ├── model/                              # Data Models
│   │   ├── auth_model/
│   │   │   ├── login_user_model.dart
│   │   │   └── ip_model.dart
│   │   └── network_call_model/
│   │       ├── api_response.dart           # ApiResponse wrapper
│   │       └── error_response.dart         # ErrorResponse parser
│   ├── network_calls/
│   │   ├── dio_client/
│   │   │   ├── dio_client.dart             # HTTP client (Dio)
│   │   │   ├── get_it_instance.dart        # DI setup (GetIt)
│   │   │   ├── base_response.dart          # Generic response models
│   │   │   ├── check_api_response.dart     # Response validator
│   │   │   └── logging_interceptor.dart    # Request/response logger
│   │   ├── api_helper/
│   │   │   ├── repository_helper/          # Repos (API call layer)
│   │   │   │   ├── auth_repo.dart
│   │   │   │   ├── home_repo.dart
│   │   │   │   ├── nursery_repo.dart
│   │   │   │   ├── account_option_repo.dart
│   │   │   │   └── address_repo.dart
│   │   │   └── provider_helper/            # Providers (business logic bridge)
│   │   │       ├── auth_provider.dart
│   │   │       ├── home_provider.dart
│   │   │       ├── nursery_provider.dart
│   │   │       ├── account_option_provider.dart
│   │   │       └── address_provider.dart
│   │   ├── exception/
│   │   │   └── api_error_handler.dart      # Dio error mapper
│   │   └── ssl_pinning/
│   │       └── ssl_pinning.dart
│   ├── services/
│   │   ├── auth_service.dart               # Auth + token + local storage
│   │   ├── globleService.dart              # Firebase token, device ID
│   │   └── translation_service.dart        # i18n
│   └── utils/
│       ├── app_constants.dart              # All API endpoints
│       ├── string_resource.dart            # Storage keys
│       └── app_setting/
│           └── app_globals.dart            # Environment flavor
├── view/                                   # UI screens
└── view_model/
    ├── controller/                         # GetX controllers
    └── routes/
        └── app_pages.dart                  # Route definitions
```

---

## Key Dependencies (pubspec.yaml)

```yaml
dio: ^5.9.0
pretty_dio_logger: ^1.4.0
get: ^4.7.2               # State management, navigation, DI
get_it: ^9.1.0             # Service locator
get_storage: ^2.1.1        # Local storage
flutter_dotenv: ^6.0.0     # Environment config
json_annotation: ^4.9.0    # JSON serialization
firebase_core, firebase_auth, firebase_messaging
```

---

## Data Flow

```
UI (View) → Controller (GetX) → Provider → Repository → DioClient → API
                                    ↓
                          CheckApiResponse
                          ↓              ↓
                     onSuccess()     onError()
```

---

## 1. Environment Config

**`app_globals.dart`** - Flavor constants:
```dart
class AppFlavor {
  static const dev = 'DEVELOPMENT';
  static const devStaging = 'DEV_STAGING';
  static const staging = 'STAGING';
  static const prod = 'PRODUCTION';
}

class Globals {
  static late final appEnvironment;
}
```

**`.env` file** (at `assets/app/.env`):
```
DEVELOPMENT_BASE_API_URL=https://dev.example.com/api
STAGING_BASE_API_URL=https://staging.example.com/api
PRODUCTION_BASE_API_URL=https://example.com/api
```

Set flavor in `main.dart`:
```dart
Globals.appEnvironment = AppFlavor.dev;
```

---

## 2. DioClient (HTTP Client)

```dart
class DioClient {
  final String baseUrl;
  final LoggingInterceptor? loggingInterceptor;
  late Dio dio;
  late String token;

  DioClient(this.baseUrl, Dio? dioC, {this.loggingInterceptor}) {
    token = Get.find<AuthService>().getUserToken();
    dio = dioC ?? Dio();
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: 600000)
      ..options.receiveTimeout = const Duration(milliseconds: 600000)
      ..options.responseType = ResponseType.json
      ..options.headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
    dio.interceptors.add(loggingInterceptor!);
    dio.interceptors.add(PrettyDioLogger(enabled: kDebugMode));
  }

  // Methods: get, post, put, patch, delete
  // Each wraps dio call in try-catch, rethrows errors
  Future<Response> get(String uri, {queryParameters, options, cancelToken, onReceiveProgress}) async { ... }
  Future<Response> post(String uri, {data, queryParameters, options, ...}) async { ... }
  Future<Response> put(String uri, {data, ...}) async { ... }
  Future<Response> patch(String uri, {data, ...}) async { ... }
  Future<Response> delete(String uri, {data, ...}) async { ... }
}
```

---

## 3. Dependency Injection (GetIt)

**`get_it_instance.dart`**:
```dart
GetIt getIt = GetIt.instance;

Future<void> getInit() async {
  // Core
  getIt.registerLazySingleton(() => DioClient(AppConstants.instance.baseUrl, getIt(), loggingInterceptor: getIt()));
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => LoggingInterceptor());

  // Repositories (LazySingleton)
  getIt.registerLazySingleton(() => AuthRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => HomeRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => NurseryRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => AccountOptionRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => AddressRepo(dioClient: getIt()));

  // Providers
  getIt.registerFactory(() => AuthProvider(authRepo: getIt()));       // Factory (new instance each time)
  getIt.registerLazySingleton(() => HomeProvider(homeRepo: getIt())); // Singleton
  getIt.registerLazySingleton(() => NurseryProvider(nurseryRepo: getIt()));
  getIt.registerLazySingleton(() => AccountOptionProvider(accountOptionRepo: getIt()));
}
```

**Pattern**: Repos = LazySingleton. Providers = LazySingleton (except AuthProvider = Factory).

---

## 4. API Response Models

### ApiResponse (Success/Error wrapper)
```dart
class ApiResponse {
  final Response? response;
  final dynamic error;

  ApiResponse.withSuccess(Response responseValue) : response = responseValue, error = null;
  ApiResponse.withError(dynamic errorValue) : response = null, error = errorValue;
}
```

### BaseResponse + Generic Responses
```dart
class BaseResponse {
  String? message;
  bool? status;
  String? token;
  factory BaseResponse.fromJson(Map<String, dynamic> json) { ... }
}

class ListResponse<T> extends BaseResponse {
  List<T> data;
  factory ListResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    // Iterates json['data'] list, applies create() factory to each item
  }
}

class SingleResponse<T> extends BaseResponse {
  T data;
  factory SingleResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    // Applies create() factory to json['data']
  }
}
```

**Expected API JSON format**:
```json
{
  "status": true,
  "message": "Success",
  "token": "optional_jwt",
  "data": { ... } or [ ... ]
}
```

### ErrorResponse
```dart
class ErrorResponse {
  List<Errors>? errors;
  ErrorResponse.fromJson(dynamic json) {
    // Parses json["errors"] map → List<Errors(code, message)>
  }
}
class Errors { final String code; final String message; }
```

**Error JSON format**:
```json
{
  "errors": {
    "email": "Email is required",
    "name": ["Name is required"]
  }
}
```

---

## 5. Repository Layer

Each repo takes `DioClient`, calls endpoints, wraps in `ApiResponse`:

```dart
class AuthRepo {
  final DioClient dioClient;
  AuthRepo({required this.dioClient});

  Future<ApiResponse> socialLogin(Map<String, dynamic> body) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.auth, data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProfile() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getProfile);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  // ... same pattern for all methods
}
```

**To add a new repo**: Create file in `repository_helper/`, inject DioClient, follow try-catch pattern.

---

## 6. Provider Layer

Providers bridge Repo → Controller via callbacks:

```dart
class AuthProvider {
  final AuthRepo authRepo;
  AuthProvider({required this.authRepo});

  Future socialLogin(
    Map<String, dynamic> body, {
    required Function(String? message) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await authRepo.socialLogin(body);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
```

**Callback signatures** (always the same):
- `onSuccess(String? message, Map<String, dynamic>? map)` - full response map
- `onError(String? message)` - error message string

---

## 7. CheckApiResponse (Response Validator)

Singleton that validates every API response:

```dart
class CheckApiResponse {
  static CheckApiResponse get instance => _instance ??= CheckApiResponse._init();

  Future<bool> initResponse(ApiResponse apiResponse, {required onSuccess, required onError}) async {
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      Map<String, dynamic> map = apiResponse.response?.data ?? {};
      String message = map["message"] ?? "";

      if (map["status"] == true || map["status"] == "OK") {
        onSuccess(message, map);   // <-- SUCCESS
        return true;
      } else if (map["errors"] != null) {
        // Parse ErrorResponse, call onError with first error message
        onError(errorMessage);
        return false;
      } else {
        onError(map["message"]);   // <-- FAILURE with message
        return false;
      }
    } else {
      // Parse error from ApiResponse.error (string or ErrorResponse)
      onError(errorMessage);
      return false;
    }
  }
}
```

---

## 8. Error Handler

```dart
class ApiErrorHandler {
  static dynamic getMessage(error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:          → "Request cancelled"
        case DioExceptionType.connectionTimeout → "Connection timeout"
        case DioExceptionType.connectionError   → "No internet"
        case DioExceptionType.receiveTimeout    → "Receive timeout"
        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case 401: → Auto logout via Get.find<AuthService>().logOut()
            case 422: → Parse ErrorResponse from response body
            case 503: → Status message
            default:  → Parse ErrorResponse or message
          }
        case DioExceptionType.sendTimeout       → "Send timeout"
      }
    }
    return errorDescription;  // String or ErrorResponse
  }
}
```

---

## 9. Controller Layer (GetX)

```dart
class SearchScreenController extends BaseViewController {
  HomeProvider homeProvider = getIt();  // Injected via GetIt

  Future searchPlantsApi({required Map<String, dynamic> data}) async {
    await homeProvider.searchPlants(data,
      onError: (errorMessage) {
        // Show toast / update error state
      },
      onSuccess: (message, data) {
        searchPlantData.value = SingleResponse<SearchResultModel>.fromJson(data!, (json) => SearchResultModel.fromJson(json));
        // Update UI state
      },
    );
  }
}
```

**Usage in controllers**: `getIt<ProviderClass>()` or direct field injection.

---

## 10. API Endpoints (AppConstants)

Singleton with all endpoints. Uses `baseUrl` from `.env`:

```dart
class AppConstants {
  static AppConstants get instance => _instance ??= AppConstants();

  late final String baseUrl = "${dotenv.env['${Globals.appEnvironment}_BASE_API_URL']}";

  // Auth
  String get auth => '$baseUrl/auth';
  String get logout => '$baseUrl/auth/logout';
  String get getProfile => '$baseUrl/profile';
  String get updateProfile => '$baseUrl/profile/update';

  // Home
  String get searchPlants => '$baseUrl/plants/search';
  String get articles => '$baseUrl/articles';

  // Nursery
  String get collection => '$baseUrl/my-nursery/collections';

  // Account
  String get faq => '$baseUrl/faqs';
  String get subscriptionPlans => '$baseUrl/subscription/plans';

  // External
  String get getUserIp => 'http://ip-api.com/json';
}
```

---

## 11. Local Storage (GetStorage)

Keys defined in `StringResource`:

| Key | Purpose |
|-----|---------|
| `currentUser` | Saved user profile JSON |
| `currentUserIp` | User IP/location data |
| `token` | Auth Bearer token |
| `fcm_token` | Firebase messaging token |
| `isFirst` | Onboarding completed flag |
| `selected_locale` | Language preference |
| `currency_symbol` | Currency symbol |
| `show_notification` | Notification toggle |

---

## 12. AuthService (Token + Session Manager)

GetxService singleton - lives for entire app lifecycle:

```dart
class AuthService extends GetxService {
  Rx<User> user = User().obs;
  GetStorage? box;

  Future<AuthService> init() async {
    box = GetStorage();
    getCurrentUserData();    // Load cached user
    getCurrentUserIpData();  // Load cached IP
    getFcmToken();           // Load cached FCM token
    return this;
  }

  // Token management
  Future<void> saveUserToken(String token) async {
    final DioClient dioClient = getIt();
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    await box?.write(StringResource.instance.token, token);
  }

  // Session checks
  bool get isFirst => box?.read(StringResource.instance.isFirst) ?? false;
  bool get isLogin => box?.hasData(StringResource.instance.currentUser) ?? false;

  // Logout - clears data, resets headers, navigates to sign-in
  Future<void> logOut() async {
    await removeUserData();
    await removeToken();
    dio.options.headers = {'Content-Type': 'application/json'};
    Get.offAllNamed(Routes.socialSignInScreen);
  }
}
```

---

## 13. App Initialization Sequence (main.dart)

```dart
Future<void> main() async {
  Globals.appEnvironment = AppFlavor.dev;       // 1. Set environment
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();                          // 2. Init all services
  runApp(GetMaterialApp(...));                   // 3. Run app
}

initServices() async {
  PackageInfoUtil.instance.initClass();          // Package info
  await Firebase.initializeApp();                // Firebase
  await dotenv.load(fileName: "assets/app/.env");// Load .env
  await getInit();                               // Register GetIt (DioClient, Repos, Providers)
  await GetStorage.init();                       // Local storage
  await Get.putAsync(() => AuthService().init());       // Auth (loads token, user)
  await Get.putAsync(() => GlobalService().init());     // Firebase token, device ID
  await Get.putAsync(() => TranslationService().init());// Translations
  MyNotification.initialize(FlutterLocalNotificationsPlugin()); // Push notifications
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
}
```

**Splash Screen Navigation**:
```dart
class SplashScreenController extends BaseViewController {
  void onReady() {
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    // isFirst=true & isLogin=true  → RootView (main app)
    // isFirst=true & isLogin=false → SocialSignInScreen
    // isFirst=false                → OnBoardScreen
    Get.offAllNamed(/* conditional route */);
  }
}
```

---

## 14. How to Add a New API Feature

### Step 1: Add endpoint in `app_constants.dart`
```dart
String get newFeature => '$baseUrl/new-feature';
```

### Step 2: Create/update Repository in `repository_helper/`
```dart
class FeatureRepo {
  final DioClient dioClient;
  FeatureRepo({required this.dioClient});

  Future<ApiResponse> getFeatureData(Map<String, dynamic> params) async {
    try {
      Response response = await dioClient.get(AppConstants.instance.newFeature, queryParameters: params);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
```

### Step 3: Create/update Provider in `provider_helper/`
```dart
class FeatureProvider {
  final FeatureRepo featureRepo;
  FeatureProvider({required this.featureRepo});

  Future getFeatureData(Map<String, dynamic> params, {
    required Function(String? message) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await featureRepo.getFeatureData(params);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
```

### Step 4: Register in `get_it_instance.dart`
```dart
getIt.registerLazySingleton(() => FeatureRepo(dioClient: getIt()));
getIt.registerLazySingleton(() => FeatureProvider(featureRepo: getIt()));
```

### Step 5: Use in Controller
```dart
class FeatureController extends BaseViewController {
  FeatureProvider featureProvider = getIt();

  Future fetchData() async {
    await featureProvider.getFeatureData({"key": "value"},
      onError: (msg) { /* handle error */ },
      onSuccess: (msg, data) {
        myData.value = SingleResponse<MyModel>.fromJson(data!, (json) => MyModel.fromJson(json));
      },
    );
  }
}
```

### Step 6: Create Model
```dart
class MyModel {
  String? id;
  String? name;
  MyModel({this.id, this.name});
  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(id: json['id'], name: json['name']);
  }
}
```

---

## Quick Reference: Patterns Summary

| Layer | Location | Pattern | Instance Type |
|-------|----------|---------|---------------|
| HTTP Client | `dio_client/dio_client.dart` | Dio wrapper | LazySingleton |
| Repository | `repository_helper/*.dart` | Try-catch → ApiResponse | LazySingleton |
| Provider | `provider_helper/*.dart` | Repo call → CheckApiResponse → callbacks | LazySingleton/Factory |
| Controller | `view_model/controller/*.dart` | GetX controller, uses `getIt()` | GetX managed |
| Response | `base_response.dart` | Generic `SingleResponse<T>` / `ListResponse<T>` | Per-call |
| Error | `api_error_handler.dart` | DioException type switch | Static |
| Validation | `check_api_response.dart` | Status check → onSuccess/onError | Singleton |
| Auth | `services/auth_service.dart` | GetxService, manages token & session | Singleton |
| Endpoints | `utils/app_constants.dart` | Getter properties with baseUrl prefix | Singleton |
| Storage | GetStorage | Key-value via StringResource keys | Singleton |
