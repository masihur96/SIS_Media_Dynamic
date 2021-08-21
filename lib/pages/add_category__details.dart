import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sis_media_admin_pannel_dynamic/database/provider/public_provider.dart';
import 'package:sis_media_admin_pannel_dynamic/model/category_model.dart';
import 'package:sis_media_admin_pannel_dynamic/pages/data_insert_page.dart';
import 'package:uuid/uuid.dart';

class AddCategoryDetails extends StatefulWidget {
  String text;
  AddCategoryDetails({required this.text});

  @override
  _AddCategoryDetailsState createState() => _AddCategoryDetailsState(text);
}

class _AddCategoryDetailsState extends State<AddCategoryDetails> {
  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _fieldController = TextEditingController();
  List<TextEditingController> textFieldControllers = [];

  String category;
  _AddCategoryDetailsState(this.category);

  int counter = 0;
  List<CategoryModel> _subList = [];

  List _fieldList = [];
  // List _valueList = [];

  Map<String, String> margeMap = {};

  Text? subText;

  customInit(PublicProvider publicProvider) async {
    print(category);

    print('List  Counter: $_subList');
    publicProvider.subCategorydataList.clear();
    publicProvider.fieldDataList.clear();
    setState(() {
      counter++;
    });
    // getFieldKey(text);
    if (publicProvider.subCategorydataList.isEmpty ||
        publicProvider.fieldDataList.isEmpty) {
      // setState(() {
      //   _isLoading = true;
      // });
      await publicProvider.fetchSubCategoryList(category).then((value) {
        setState(() {
          _subList = publicProvider.subCategorydataList;
          print('List  Counter: ${_subList.length}');

          // _isLoading = false;
        });
      });

      await publicProvider.fetchFieldList(category).then((value) {
        setState(() {
          _fieldList = publicProvider.fieldDataList;
          print('List  Counter: ${_fieldList.length}');

          if (_fieldList.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DataInsertPage(
                          text: category,
                        )));
          }

          // _isLoading = false;
        });
      });
    } else {
      setState(() {
        _subList = publicProvider.subCategorydataList;
        _fieldList = publicProvider.fieldDataList;
      });

      if (_fieldList.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DataInsertPage(
                      text: category,
                    )));
      }
    }
  }

  getData(PublicProvider publicProvider) async {
    // setState(() {
    //   _isLoading = true;
    // });
    _subList.clear();
    await publicProvider.fetchSubCategoryList(category).then((value) {
      setState(() {
        _subList = publicProvider.subCategorydataList;

        //  _isLoading = false;
      });
    });
  }

  getFieldData(PublicProvider publicProvider) async {
    // setState(() {
    //   _isLoading = true;
    // });
    _fieldList.clear();
    await publicProvider.fetchFieldList(category).then((value) {
      setState(() {
        _fieldList = publicProvider.fieldDataList;

        //  _isLoading = false;
      });
    });
  }

  // Map<dynamic, dynamic> margeMap = new Map();

  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    if (counter == 0) {
      customInit(publicProvider);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(category),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: size.width * .5,
                height: size.height,
                color: Colors.grey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: size.width * .5,
                          color: Colors.blueGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Add Sub-Category:'),
                          )),
                      Container(
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: _subList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  _subList[index].subCategory == ''
                                      ? Container()
                                      : setState(() {
                                          _isExpanded = !_isExpanded;
                                          subText = Text(
                                              _subList[index].subCategory!);
                                        });
                                  //  print('subText : $subText');
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        _subList[index].subCategory == ''
                                            ? Container()
                                            : Text(_subList[index].subCategory!,
                                                style: TextStyle(fontSize: 23)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _subCategoryController,
                          decoration: InputDecoration(
                            hintText: "Add  Sub-Category",
                            suffixIcon: IconButton(
                              onPressed: () {
                                final String uuid = Uuid().v1();

                                if (_subCategoryController.text != '') {
                                  publicProvider
                                      .addSubCategoryData(category,
                                          _subCategoryController.text, uuid)
                                      .then((value) {
                                    if (value = true) {
                                      _showSnackBar('Data Insert Successfully');
                                    } else {
                                      _showSnackBar("Insert Failed");
                                    }
                                  });

                                  _subCategoryController.clear();
                                } else {
                                  print('TextField is Empty');
                                }

                                getData(publicProvider);
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              Container(
                width: size.width * .5,
                height: size.height,
                child: Column(
                  children: [
                    Container(
                        width: size.width * .5,
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Add Field:'),
                        )),
                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: _fieldList.length,
                          itemBuilder: (BuildContext context, int index) {
                            // textFieldControllers[index] =
                            //     TextEditingController();
                            for (var i = 0; i < _fieldList.length; i++) {
                              textFieldControllers.add(TextEditingController());
                            }

                            return InkWell(
                              onTap: () {
                                print(subText);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('${_fieldList[index]}  : '),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataInsertPage(
                                      text: category,
                                    )),
                          );
                        },
                        child: Text('Add Data')),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _fieldController,
                        decoration: InputDecoration(
                          hintText: "Add  Field",
                          suffixIcon: IconButton(
                            onPressed: () {
                              print(_fieldList.length);
                              final String uuid = Uuid().v1();
                              if (_fieldController.text != '') {
                                publicProvider
                                    .addField(category, subText.toString(),
                                        uuid, _fieldController.text)
                                    .then((value) {
                                  if (value = true) {
                                    _showSnackBar('Data Insert Successfully');
                                  } else {
                                    _showSnackBar("Insert Failed");
                                  }
                                });

                                _fieldController.clear();
                              } else {
                                print('TextField is Empty');
                              }

                              getFieldData(publicProvider);
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String messege) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        content: Text(
          messege,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        )));
  }
}
