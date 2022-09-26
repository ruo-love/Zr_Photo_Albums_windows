import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:test_pc/model/model.dart';

const String host = 'http://114.132.197.72:3005';

// const String host = 'http://localhost:3005';
BaseOptions options = BaseOptions(baseUrl: '${host}/api/file/');
Dio request = Dio(options);

Future<bool> submit(Iterable<ImageFile> images, String category) async {
// return Iterable<ImageFile>
  List<MultipartFile> files = [];
  for (final image in images) {
    if (image.hasPath) {
      MultipartFile res =
          MultipartFile.fromFileSync(image.path!, filename: image.name);
      files.add(res);
    }
  }
  print(category);
  var formData = FormData.fromMap({'files': files});
  bool isOk;
  try {
    await request.post('upload/${category}', data: formData);
    isOk = true;
  } catch (e) {
    isOk = false;
  }

  return isOk;
}

Future<bool> remove(String id) async {
  bool isOk;
  try {
    var res = await request.delete('remove/${id}');
    isOk = true;
    PhotoModel data = PhotoModel.fromJson(res.data);
  } catch (e) {
    isOk = false;
  }

  return isOk;
}

class Res {
  List<PhotoItemModel> data;
  bool hasMore;
  int total;
  Res(this.data, this.hasMore, this.total);
}

Future<Res> getFiles({
  required int page,
  required int limit,
  required String category,
}) async {
  print('${page}, ${limit}, ${category}');
  var res = await request.get('files',
      queryParameters: {'page': page, 'limit': limit, 'category': category});

  PhotoModel data = PhotoModel.fromJson(res.data);

  return Res(data.dataList!, data.hasMore!, data.total!);
}
