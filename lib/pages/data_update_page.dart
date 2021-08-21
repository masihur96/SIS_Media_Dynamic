import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sis_media_admin_pannel_dynamic/database/provider/public_provider.dart';

class DataUpdatePage extends StatefulWidget {
  Map<String, dynamic>? itemMap;

  DataUpdatePage({
    required this.itemMap,
  });
  @override
  _DataUpdatePageState createState() => _DataUpdatePageState(itemMap);
}

class _DataUpdatePageState extends State<DataUpdatePage> {
  Map<String, dynamic>? itemMap;
  _DataUpdatePageState(this.itemMap);

  List<TextEditingController> textFieldControllers = [];

  String category = '';
  String id = '';
  String subCategory = '';

  List keyList = [];

  visibilityWidget() {}

  Map<String, String> margeMap = {};

  int counter = 0;
  customInit(PublicProvider publicProvider) async {
    keyList.clear();
    category = itemMap!['category'];
    id = itemMap!['id'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    if (counter == 0) {
      customInit(publicProvider);
    }
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    width: size.width,
                    height: size.height,
                    child: Column(children: [
                      Container(
                          width: size.width,
                          color: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Update Data'),
                          )),
                      Container(
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: itemMap!.length,
                            itemBuilder: (BuildContext context, int index) {
                              // textFieldControllers[index] =
                              //     TextEditingController();
                              for (var i = 0; i < itemMap!.length; i++) {
                                textFieldControllers
                                    .add(TextEditingController());
                              }

                              return InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    itemMap!.keys.elementAt(index) == 'id' ||
                                            itemMap!.keys.elementAt(index) ==
                                                'category' ||
                                            itemMap!.keys.elementAt(index) ==
                                                'subCategory'
                                        ? Container()
                                        : Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(itemMap!.keys
                                                      .elementAt(index)),
                                                  Expanded(
                                                    child: TextFormField(
                                                      initialValue: itemMap!
                                                          .values
                                                          .elementAt(index),

                                                      // controller:
                                                      //     textFieldControllers[
                                                      //         index],
                                                      //

                                                      decoration:
                                                          InputDecoration(
                                                        hintText: itemMap!
                                                            .values
                                                            .elementAt(index),
                                                      ),
                                                      onChanged: (text) {
                                                        setState(() {
                                                          itemMap![itemMap!.keys
                                                                  .elementAt(
                                                                      index)] =
                                                              textFieldControllers[
                                                                      index]
                                                                  .text;
                                                        });
                                                      },
                                                    ),
                                                  ),
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
                            publicProvider.updateItemData(
                                itemMap!, category, id, context);
                          },
                          child: Text('Add Data'))
                    ])))));
  }
}
