import 'dart:io';
import 'dart:typed_data';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_pc/config/app_color.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:test_pc/config/state.dart';
import 'package:test_pc/request/request.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String category = 'work';
  List<DropdownMenuItem<String>> dropList = [
    getDropdownMenuItem<String>(
      '工作',
      'work',
    ),
    getDropdownMenuItem<String>(
      '生活',
      'life',
    ),
    getDropdownMenuItem<String>(
      '学习',
      'study',
    ),
    getDropdownMenuItem<String>(
      '其他',
      'other',
    ),
  ];
  bool loading = false;
  MultiImagePickerController controller = MultiImagePickerController(
    maxImages: 10,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor:
                Provider.of<ThemeChangeNotifier>(context, listen: true).primary,
            actions: [
              DropdownButton(
                  dropdownColor:
                      Provider.of<ThemeChangeNotifier>(context, listen: true)
                          .primary,
                  items: dropList,
                  onChanged: (v) {
                    setState(() {
                      category = v as String;
                    });
                  })
            ]),
        floatingActionButton: FloatingActionButton(
          tooltip: '上传',
          backgroundColor:
              Provider.of<ThemeChangeNotifier>(context, listen: true).primary,
          onPressed: () async {
            setState(() {
              loading = true;
            });
            await submit(controller.images, category);

            setState(() {
              loading = false;
              controller = MultiImagePickerController(
                maxImages: 10,
                allowedImageTypes: ['png', 'jpg', 'jpeg'],
              );
            });
          },
          child: Icon(Icons.send_rounded, color: Colors.white),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: loading
              ? LoadingAnimationWidget.twistingDots(
                  leftDotColor: const Color(0xFF1A1A3F),
                  rightDotColor: const Color(0xFFEA3799),
                  size: 200,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: MultiImagePickerView(
                          controller: controller,
                          padding: const EdgeInsets.all(0),
                          initialContainerBuilder: (context, pickerCallback) =>
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Provider.of<ThemeChangeNotifier>(
                                            context,
                                            listen: true)
                                        .primary
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50)),
                                child: IconButton(
                                  mouseCursor: SystemMouseCursors.click,
                                  onPressed: pickerCallback,
                                  icon: Icon(
                                    Icons.backup,
                                    color: Provider.of<ThemeChangeNotifier>(
                                            context,
                                            listen: true)
                                        .primary,
                                    size: 120,
                                  ),
                                ),
                              ),
                          itemBuilder: (context, file, deleteCallback) =>
                              Container(
                                margin: EdgeInsets.all(6),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5, //阴影范围
                                      spreadRadius: 5,
                                      offset: Offset(5, 5),
                                      //阴影浓度
                                      color:
                                          Colors.grey.withOpacity(0.2), //阴影颜色
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      !file.hasPath
                                          ? Image.memory(
                                              file.bytes!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Center(
                                                    child: Text('No Preview'));
                                              },
                                            )
                                          : Image.file(
                                              File(file.path!),
                                              fit: BoxFit.cover,
                                            ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            tooltip: '删除',
                                            onPressed: () {
                                              deleteCallback(file);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Provider.of<
                                                          ThemeChangeNotifier>(
                                                      context,
                                                      listen: true)
                                                  .primary,
                                              size: 30,
                                            )),
                                      ),
                                    ]),
                              ),
                          addMoreBuilder: (context, pickerCallback) =>
                              Container(
                                decoration: BoxDecoration(
                                    color: Provider.of<ThemeChangeNotifier>(
                                            context,
                                            listen: true)
                                        .primary,
                                    borderRadius: BorderRadius.circular(70)),
                                child: IconButton(
                                    tooltip: '添加',
                                    onPressed: pickerCallback,
                                    icon: Icon(
                                      Icons.backup,
                                      color: AppColor.primary_shallow,
                                    )),
                              )),
                    )
                  ],
                ),
        ));
  }
}

DropdownMenuItem<T> getDropdownMenuItem<T>(String text, T value) {
  return DropdownMenuItem(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    ),
    value: value,
  );
}
