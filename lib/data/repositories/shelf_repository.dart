import 'dart:convert';

import 'package:capstone/data/data_providers/data_providers.dart';
import 'package:capstone/data/models/models.dart';

class ShelfRepository {
  final ShelfApi _api = new ShelfApi();
  Future<Shelf> getShelf(String shelfName) async {
    final String rawBody = await _api.getShelf(shelfName);
    var jsonResponse = json.decode(rawBody);
    return Shelf.fromJson(jsonResponse);
  }

  Future<List<Shelf>> getShelves(String storeId, String shelfName, int statusId,
      int pageNum, int fetchNext) async {
    final String rawBody =
        await _api.getShelves(storeId, shelfName, statusId, pageNum, fetchNext);

    var jsonResponse = json.decode(rawBody);
    if (jsonResponse
        .toString()
        .contains(ErrorCodeAndMessage.errorCodeAndMessage)) {
      return null;
    }
    print("======================================\n");
    String total;
    for (var entry in jsonResponse.entries) {
      if (entry.key.toString().contains('totalOfRecord')) {
        total = entry.value.toString();
      }
    }
    print(total);

    return (jsonResponse['shelves'] as List)
        .map((e) => Shelf.fromJsonLst(e))
        .toList();
  }

  Future<List<Shelf>> getShelvesByStoreId(String storeId) async {
    final String rawBody = await _api.getShelvesByStoreId(storeId);

    var jsonResponse = json.decode(rawBody);
    if (jsonResponse
        .toString()
        .contains(ErrorCodeAndMessage.errorCodeAndMessage)) {
      return null;
    }
    return (jsonResponse['shelves'] as List)
        .map((e) => Shelf.fromJsonLst(e))
        .toList();
  }

  Future<String> changeStatus(
      String shelfId, int statusId, String reasonInactive) async {
    Map<String, dynamic> jsonChangeStatus;
    if (reasonInactive == null) {
      jsonChangeStatus = {
        "shelfId": shelfId,
        "statusId": statusId,
      };
    } else {
      jsonChangeStatus = {
        "shelfId": shelfId,
        "statusId": statusId,
        "reasonInactive": reasonInactive,
      };
    }
    var userCreateJson = jsonEncode(jsonChangeStatus);
    final String response = await _api.changeStatus(userCreateJson);
    if (response.contains("MSG")) {
      return parseJsonToMessage(response);
    }
    return response;
  }

  Future<String> changeCamera(
      String shelfId, String cameraId, int action) async {
    Map<String, dynamic> jsonMapStore = {
      "shelfId": shelfId,
      "cameraId": cameraId,
      "action": action,
    };
    var jsonUpt = jsonEncode(jsonMapStore);
    String response = await _api.changeCamera(jsonUpt);
    if (response.contains("MSG")) {
      return parseJsonToMessage(response);
    }
    return 'true';
  }

  Future<String> updateShelf(Shelf shelf) async {
    var shelfCreateJson = jsonEncode(shelf.toJson());
    final String response = await _api.updateShelf(shelfCreateJson);
    if (response.contains("MSG")) {
      return parseJsonToMessage(response);
    }
    return response;
  }

  Future<String> postShelf(Shelf shelf, String storeId) async {
    Map<String, dynamic> jsonMapCamera = {
      "storeId": storeId,
      "shelfName": shelf.shelfName,
      "description": shelf.description,
      "numberOfStack": shelf.numberOfStack,
    };
    var shelfCreateJson = jsonEncode(jsonMapCamera);
    final String response = await _api.postShelf(shelfCreateJson);
    if (response.contains("MSG")) {
      return parseJsonToMessage(response);
    }
    return response;
  }
}
