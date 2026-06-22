
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/address_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/nursery_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/account_option_repo.dart';

import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/address_repo.dart';

import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/home_repo.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/nursery_repo.dart';

import '../../utils/app_constants.dart';
import '../api_helper/provider_helper/auth_provider.dart';
import '../api_helper/repository_helper/auth_repo.dart';
import 'dio_client.dart';
import 'logging_interceptor.dart';

GetIt getIt = GetIt.instance;

Future<void> getInit() async {
  /// Core
  getIt.registerLazySingleton(() => DioClient(AppConstants.instance.baseUrl, getIt(), loggingInterceptor: getIt(),));

  /// External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => LoggingInterceptor());

  /// Repository
  getIt.registerLazySingleton(() => AuthRepo(dioClient: getIt(),));

  getIt.registerLazySingleton(() => AddressRepo(dioClient: getIt(),));

  getIt.registerLazySingleton(() => HomeRepo(dioClient: getIt(),));
  getIt.registerLazySingleton(() => NurseryRepo(dioClient: getIt(),));

  getIt.registerLazySingleton(() => AccountOptionRepo(dioClient: getIt(),));






  /// Provider
  getIt.registerFactory(() => AuthProvider(authRepo: getIt()));

  getIt.registerLazySingleton(() => HomeProvider(homeRepo: getIt()));
  getIt.registerLazySingleton(() => NurseryProvider(nurseryRepo: getIt()));

  getIt.registerLazySingleton(() => AccountOptionProvider(accountOptionRepo: getIt(),));







}
