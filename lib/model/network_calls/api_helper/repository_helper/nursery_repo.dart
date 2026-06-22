




import 'package:dio/dio.dart';
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/dio_client.dart';
import 'package:plants_spotify/model/network_calls/exception/api_error_handler.dart';
import 'package:plants_spotify/model/utils/app_constants.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

class NurseryRepo {
  final DioClient dioClient;
  NurseryRepo({
    required this.dioClient,
  });


  /// get collections
  Future<ApiResponse> getCollections(String? plantId) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.collection}${plantId != null ? "?plant_id=${plantId ?? ""}":""}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// create collections
  Future<ApiResponse> createCollection(Map<String, dynamic> createCollectionBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.collection,data: createCollectionBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// update collections
  Future<ApiResponse> updateCollection(Map<String, dynamic> updateCollectionBody) async {
    try {
      Response response = await dioClient.put("${AppConstants.instance.collection}/${updateCollectionBody["id"]}",data: updateCollectionBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// delete collections
  Future<ApiResponse> deleteCollection(Map<String, dynamic> deleteCollectionBody) async {
    try {
      Response response = await dioClient.delete("${AppConstants.instance.collection}/${deleteCollectionBody["id"]}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// add plant to collection
  Future<ApiResponse> addPlantToCollection(Map<String, dynamic> addPlantToCollectionBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.addPlantToCollection,data: addPlantToCollectionBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// remove plant from collection
  Future<ApiResponse> removePlantFromCollection(Map<String, dynamic> removePlantFromCollectionBody) async {
    try {
      Response response = await dioClient.delete("${AppConstants.instance.myNurseryPlants}/${removePlantFromCollectionBody['id']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// move plant to other collection
  Future<ApiResponse> movePlantToOtherCollection(Map<String, dynamic> removePlantFromCollectionBody) async {
    try {
      Response response = await dioClient.put("${AppConstants.instance.myNurseryPlants}/${removePlantFromCollectionBody['id']}/move");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// Get Collection Plants
  Future<ApiResponse> getCollectionPlants(Map<String, dynamic> getCollectionPlantsBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.collection}/${getCollectionPlantsBody['id']}/plants?paginate=${getCollectionPlantsBody['paginate']}&page=${getCollectionPlantsBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Add plant note
  Future<ApiResponse> addPlantNote(int id,FormData getCollectionPlantsBody) async {
    try {
      Response response = await dioClient.post("${AppConstants.instance.myNurseryPlants}/$id/activities",data: getCollectionPlantsBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get plant note
  Future<ApiResponse> getPlantNote(Map<String, dynamic> getPlantNoteBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.myNurseryPlants}/${getPlantNoteBody['id']}/activities?paginate=${getPlantNoteBody['paginate']}&page=${getPlantNoteBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// edit plant note
  Future<ApiResponse> editPlantNote(int userPlantId ,int noteId,FormData editPlantNoteData) async {
    try {
      Response response = await dioClient.post("${AppConstants.instance.myNurseryPlants}/$userPlantId/activities/$noteId",data: editPlantNoteData);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// delete plant note
  Future<ApiResponse> deletePlantNote(int userPlantId ,int noteId) async {
    try {
      Response response = await dioClient.delete("${AppConstants.instance.myNurseryPlants}/$userPlantId/activities/$noteId");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
