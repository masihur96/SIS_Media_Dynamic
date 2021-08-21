import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sis_media_admin_pannel_dynamic/database/provider/public_provider.dart';
import 'package:uuid/uuid.dart';

class CategoryInsertPage extends StatefulWidget {
  @override
  _CategoryInsertPageState createState() => _CategoryInsertPageState();
}

class _CategoryInsertPageState extends State<CategoryInsertPage> {
  TextEditingController _categoryName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Add Page"),
        elevation: 8,
      ),
      body: _bodyUI(publicProvider),
    );
  }

  Widget _bodyUI(PublicProvider publicProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _textFormBuilder("Category Name"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    final String uuid = Uuid().v1();
                    if (_formKey.currentState!.validate()) {
                      publicProvider
                          .insertData(_categoryName.text, uuid)
                          .then((value) {
                        if (value = true) {
                          _showSnackBar('Data Insert Successfully');
                        } else {
                          _showSnackBar("Insert Failed");
                        }
                      });
                    }

                    publicProvider.fetchCategoryListData();
                  },
                  child: Text(
                    "Insert Data",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFormBuilder(String hint) {
    return TextFormField(
      controller: hint == 'Category Name' ? _categoryName : _categoryName,
      validator: (value) {
        if (value!.isEmpty)
          return 'Enter $hint';
        else
          return null;
      },
      decoration: InputDecoration(hintText: hint),
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
