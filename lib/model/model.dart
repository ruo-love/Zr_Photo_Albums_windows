import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_pc/config/app_color.dart';

class NavTitleMode {
  String title;
  Icon icon;
  int? id;
  Icon rightIcon;

  NavTitleMode({
    this.title = 'title',
    this.id,
    this.icon = const Icon(
      Icons.list_alt_outlined,
      color: AppColor.primary_shallow,
    ),
    this.rightIcon = const Icon(
      Icons.arrow_forward_ios,
      color: AppColor.primary_shallow,
    ),
  });
}

class PhotoModel {
  List<PhotoItemModel>? dataList;
  int? total;
  bool? hasMore;
  PhotoModel({this.dataList, this.total, this.hasMore});

  PhotoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      total = json['total'];
      hasMore = json['hasMore'];
      dataList = <PhotoItemModel>[];
      json['data'].forEach((v) {
        dataList!.add(new PhotoItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataList != null) {
      data['data'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhotoItemModel {
  String? id;
  String? category;
  String? url;
  int? createTime;

  PhotoItemModel({this.id, this.category, this.url, this.createTime});

  PhotoItemModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    category = json['category'];
    url = json['url'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['category'] = this.category;
    data['url'] = this.url;
    data['createTime'] = this.createTime;
    return data;
  }
}
