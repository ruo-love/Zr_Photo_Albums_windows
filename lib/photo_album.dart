import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:test_pc/config/app_color.dart';
import 'package:test_pc/config/state.dart';
import 'package:test_pc/model/model.dart';
import 'package:test_pc/request/request.dart';
import 'package:test_pc/upload_page.dart';

class PhotoAlbumPage extends StatefulWidget {
  PhotoAlbumPage({Key? key}) : super(key: key);

  @override
  State<PhotoAlbumPage> createState() => _PhotoAlbumPageState();
}

class _PhotoAlbumPageState extends State<PhotoAlbumPage>
    with AutomaticKeepAliveClientMixin {
  int limit = 10;
  int page = 0;
  String category = 'all';
  List<PhotoItemModel> _photoList = [];
  bool hasMore = false;
  bool loading = true;
  bool error = false;
  String errorMsg = '加载完毕';
  int total = 0;
  late EasyRefreshController _easy_controller;
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  List<DropdownMenuItem<String>> dropList = [
    getDropdownMenuItem<String>(
      '全部',
      'all',
    ),
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easy_controller = EasyRefreshController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _easy_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: Center(child: Text(total.toString() + ' 张')),
        backgroundColor:
            Provider.of<ThemeChangeNotifier>(context, listen: true).primary,
        actions: [
          DropdownButton(
              dropdownColor:
                  Provider.of<ThemeChangeNotifier>(context, listen: true)
                      .primary,
              items: dropList,
              value: category,
              onChanged: (v) {
                setState(() {
                  category = v as String;
                  page = 0;
                });
                _getCloudFiles();
              }),
        ],
      ),
      body: EasyRefresh(
        firstRefresh: true,
        header: ClassicalHeader(
            refreshText: '小若正在拼命加载',
            refreshFailedText: '加载失败',
            refreshReadyText: '准备刷新',
            refreshingText: '正在刷新',
            showInfo: false,
            textColor: AppColor.primary_text,
            refreshedText: '小若刷新完成'),
        footer: ClassicalFooter(
            loadText: '小若正在拼命加载',
            loadedText: '小若加载完成',
            loadReadyText: '准备加载',
            loadingText: '小若正在加载',
            showInfo: false,
            noMoreText: '图床加载完毕',
            textColor: AppColor.primary_text,
            loadFailedText: '加载失败'),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        controller: _easy_controller,
        onRefresh: _onRefresh,
        onLoad: _photoList.isEmpty ? null : _onLoad,
        child: gridBody(),
      ),
    );
  }

  Widget gridBody() {
    return GridView.builder(
      controller: ScrollController(),
      padding: const EdgeInsets.only(top: 7),
      itemCount: _photoList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: MediaQuery.of(context).size.width / 4,
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (_, index) => Container(
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
              color: Colors.grey.withOpacity(0.2), //阴影颜色
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(alignment: Alignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network('${host}/${_photoList[index].url}'),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
                tooltip: '删除',
                onPressed: () {
                  remove(_photoList[index].id!);
                  setState(() {
                    _photoList = _photoList
                        .where((e) => e.id != _photoList[index].id!)
                        .toList();
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Provider.of<ThemeChangeNotifier>(context, listen: true)
                      .primary,
                  size: 30,
                )),
          ),
        ]),
      ),
    );
  }

  Future _getCloudFiles({bool push = false}) async {
    try {
      page++;

      Res res = await getFiles(limit: limit, page: page, category: category);
      setState(() {
        if (push) {
          _photoList.addAll(res.data);
        } else {
          _photoList = res.data;
        }
        hasMore = res.hasMore;
        total = res.total;
      });
    } catch (err) {
      setState(() {
        error = true;
        errorMsg = err.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // 刷新回调(null为不开启刷新)
  Future _onRefresh() async {
    page = 0;
    await _getCloudFiles();
    // 恢复刷新状态 使onLoad再次可用
    _easy_controller.finishRefresh(noMore: !hasMore);
  }

  // 加载回调(null为不开启加载)
  Future _onLoad() async {
    if (hasMore) {
      await _getCloudFiles(push: true);
    }
    // 结束加载
    _easy_controller.finishLoad(noMore: !hasMore);
  }
}
