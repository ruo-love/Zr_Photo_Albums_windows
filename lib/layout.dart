import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_pc/config/app_color.dart';
import 'package:test_pc/config/state.dart';
import 'package:test_pc/model/model.dart';

import 'package:test_pc/photo_album.dart';
import 'package:test_pc/settings.dart';
import 'package:test_pc/upload_page.dart';

class LayoutPage extends StatefulWidget {
  LayoutPage({Key? key}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  List<NavTitleMode> _navList = [
    NavTitleMode(
        title: '上传',
        id: 0,
        icon: Icon(
          Icons.backup,
          color: AppColor.primary_shallow,
        )),
    NavTitleMode(
        title: '图库',
        id: 1,
        icon: Icon(
          Icons.perm_media,
          color: AppColor.primary_shallow,
        )),
    NavTitleMode(
      title: '设置',
      id: 2,
      icon: Icon(
        Icons.settings,
        color: AppColor.primary_shallow,
      ),
    ),
  ];
  List<Widget> _pages = [UploadPage(), PhotoAlbumPage(), SettingsPage()];
  int _currentNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Provider.of<ThemeChangeNotifier>(context, listen: true).primary,
        body: Container(
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                            color: Colors.white.withOpacity(0.5),
                          )),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          itemCount: _navList.length,
                          itemBuilder: ((context, index) => ListTile(
                                selected: _currentNavIndex == index,
                                leading: _navList[index].icon,
                                trailing: _navList[index].rightIcon,
                                tileColor: Provider.of<ThemeChangeNotifier>(
                                        context,
                                        listen: true)
                                    .primary,
                                selectedTileColor:
                                    Color.fromARGB(255, 21, 22, 22),
                                title: Text(
                                  _navList[index].title,
                                  style: TextStyle(
                                    color: AppColor.primary_shallow,
                                    fontSize: 14,
                                    fontFamily: "YouYuan",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  if (_navList[index].id == 0 ||
                                      _navList[index].id == 1 ||
                                      _navList[index].id == 2) {
                                    setState(() {
                                      _currentNavIndex = _navList[index].id!;
                                    });
                                  }
                                },
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: _pages[_currentNavIndex],
              )
            ],
          ),
        ));
  }
}
