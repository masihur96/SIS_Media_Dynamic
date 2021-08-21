import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sis_media_admin_pannel_dynamic/database/provider/public_provider.dart';
import 'package:sis_media_admin_pannel_dynamic/pages/data_update_page.dart';

class AllData extends StatefulWidget {
  String text;
  AllData({required this.text});

  @override
  _AllDataState createState() => _AllDataState(text);
}

class _AllDataState extends State<AllData> {
  String category;
  _AllDataState(this.category);

  int counter = 0;
  List _dataList = [];

  List _fieldList = [];

  customInit(PublicProvider publicProvider) async {
    // publicProvider.dataList.clear();
    // _dataList.clear();

    // getData(publicProvider);

    _fieldList = publicProvider.fieldDataList;
    print(_fieldList);

    setState(() {
      counter++;
    });

    await publicProvider.fetchCategoryData(category).then((value) {
      setState(() {
        _dataList = publicProvider.dataList;
      });
    });

    await publicProvider.fetchCategoryData(category).then((value) {
      setState(() {
        _dataList = publicProvider.dataList;
      });
    });
  }

  getData(PublicProvider publicProvider) async {
    _dataList.clear();

    await publicProvider.fetchCategoryData(category).then((value) {
      setState(() {
        _dataList = publicProvider.dataList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    if (counter == 0) {
      customInit(publicProvider);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();

            print(_dataList);
          },
        ),
        title: Text(category),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: _dataList.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _dataList[index].length,
                    itemBuilder: (_, int i) {
                      String key = _dataList[index].keys.elementAt(i);

                      return key == 'id' ||
                              key == 'category' ||
                              key == 'subCategory'
                          ? Container()
                          : Container(
                              child: Row(
                                children: [
                                  Text(key, style: TextStyle(fontSize: 21)),
                                  Text(
                                    " :  ${_dataList[index][key]}",
                                    style: TextStyle(fontSize: 21),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                  Positioned(
                      right: 0,
                      child: Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DataUpdatePage(
                                            itemMap: _dataList[index],
                                          )),
                                );
                              },
                              child: Text('Update')),
                          ElevatedButton(
                              onPressed: () {
                                String id = _dataList[index]["id"];
                                publicProvider.deleteItemData(
                                    context, id, category);
                              },
                              child: Text('Delete')),
                        ],
                      )),
                ],
              );
            }),
      ),
    );
  }
}
