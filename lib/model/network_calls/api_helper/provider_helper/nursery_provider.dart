
import 'package:dio/dio.dart';
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/home_repo.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/nursery_repo.dart';

import 'package:plants_spotify/model/network_calls/dio_client/check_api_response.dart';

class NurseryProvider {
  final NurseryRepo nurseryRepo;
  NurseryProvider({required this.nurseryRepo});



  /// get Collections
  Future getCollections({String? plantId,required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.getCollections(plantId);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// createCollection
  Future createCollection(Map<String, dynamic> createCollectionBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.createCollection(createCollectionBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// update Collection
  Future updateCollection(Map<String, dynamic> updateCollectionBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.updateCollection(updateCollectionBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// delete Collection
  Future deleteCollection(Map<String, dynamic> deleteCollectionBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.deleteCollection(deleteCollectionBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// add plant To Collection
  Future addPlantToCollection(Map<String, dynamic> addPlantToCollectionBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.addPlantToCollection(addPlantToCollectionBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }


  /// remove plant from collection
  Future removePlantFromCollection(Map<String, dynamic> removePlantFromCollectionBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.removePlantFromCollection(removePlantFromCollectionBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// move plant to other collection
  Future movePlantToOtherCollection(Map<String, dynamic> movePlantToOtherCollectionBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.movePlantToOtherCollection(movePlantToOtherCollectionBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }



  /// get Collection Plants
  Future getCollectionPlants(Map<String, dynamic> getCollectionPlantsBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.getCollectionPlants(getCollectionPlantsBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// add plant note
  Future addPlantNote({required id,required FormData data,required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.addPlantNote(id,data);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// get plant note
  Future getPlantNote(Map<String, dynamic> getPlantNoteBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.getPlantNote(getPlantNoteBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// edit plant note
  Future editPlantNote({required int userPlantId ,required int noteId,required FormData data,required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.editPlantNote(userPlantId,noteId,data);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// delete plant note
  Future deletePlantNote({required int userPlantId ,required int noteId,required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await nurseryRepo.deletePlantNote(userPlantId,noteId);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }





}
