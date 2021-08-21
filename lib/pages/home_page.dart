import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sis_media_admin_pannel_dynamic/database/provider/public_provider.dart';
import 'package:sis_media_admin_pannel_dynamic/model/category_model.dart';
import 'package:sis_media_admin_pannel_dynamic/pages/add_category__details.dart';
import 'package:sis_media_admin_pannel_dynamic/pages/all_data_page.dart';
import 'package:sis_media_admin_pannel_dynamic/pages/category_create_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  List<CategoryModel> _subList = [];

  List _fieldList = [];

  customInit(PublicProvider publicProvider) async {
    //  _subList.clear();

    setState(() {
      counter++;
    });

    _fieldList = publicProvider.fieldDataList;

    print(_fieldList);

    // await publicProvider.fetchCategoryListData().then((value) {
    //   setState(() {
    //     _subList = publicProvider.categoryList;
    //     print('List  Counter: ${publicProvider.categoryList.length}');
    //     // _isLoading = false;
    //   });
    // });

    if (publicProvider.categoryList.isEmpty) {
      // setState(() {
      //   _isLoading = true;
      // });
      await publicProvider.fetchCategoryListData().then((value) {
        setState(() {
          _subList = publicProvider.categoryList;
          print('List  Counter: ${_subList.length}');

          // _isLoading = false;
        });
      });
    } else {
      setState(() {
        _subList = publicProvider.categoryList;
      });
    }
  }

  getData(PublicProvider publicProvider) async {
    // setState(() {
    //   _isLoading = true;
    // });
    _subList.clear();
    await publicProvider.fetchCategoryListData().then((value) {
      setState(() {
        _subList = publicProvider.categoryList;

        //  _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    if (counter == 0) {
      customInit(publicProvider);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("FirebaseApp"),
          elevation: 8,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getData(publicProvider);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryInsertPage()));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          tooltip: 'Insert Data',
        ),
        body: Container(
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size.width < 600
                      ? 1
                      : size.width < 700
                          ? 2
                          : size.width < 1300
                              ? 3
                              : 4,
                  childAspectRatio: .9),
              itemCount: _subList.length,
              itemBuilder: (BuildContext ctx, index) {
                return Stack(
                  children: [
                    Container(
                      width: size.height * .6,
                      height: size.height * .23,
                      margin: EdgeInsets.only(
                          top: size.height * .05,
                          left: size.height * .02,
                          right: size.height * .02),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.height * .02,
                          vertical: size.height * .02),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300, blurRadius: 5)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'heading1',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.height * .016,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text('h1Data',
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: size.height * .022,
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(height: size.height * .01),
                              Text(
                                'heading2',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.height * .016,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text('h2Data',
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: size.height * .022,
                                    fontWeight: FontWeight.w400,
                                  )),
                              Divider(
                                  height: 3,
                                  thickness: 0.2,
                                  color: Colors.grey),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllData(
                                                text: _subList[index].category!,
                                              )),
                                    );

                                    //   print(_subList[index].category!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  child: Text('View All',
                                      style: TextStyle(
                                          fontSize: size.height * .025,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCategoryDetails(
                                                  text:
                                                      _subList[index].category!,
                                                )),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.grey,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        textStyle: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    child: Text('Insert Data',
                                        style: TextStyle(
                                            fontSize: size.height * .025,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)))
                              ])
                        ],
                      ),
                    ),
                    Positioned(
                      left: size.height * .04,
                      top: size.height * .02,
                      child: Container(
                        height: size.height * .1,
                        width: size.height * .1,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 10,
                              )
                            ]),
                        child: Text(_subList[index].category!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * .02,
                            )),
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
