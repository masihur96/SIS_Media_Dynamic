import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:sis_media_admin_pannel_dynamic/model/category_model.dart';

class PublicProvider extends ChangeNotifier {
  List<CategoryModel> _categoryList = [];
  get categoryList => _categoryList;

  List<CategoryModel> _subCategorydataList = [];
  get subCategorydataList => _subCategorydataList;

  // List _subCategoryItemList = [];
  // get subCategoryItemList => _subCategoryItemList;

  List _fieldDataList = [];
  get fieldDataList => _fieldDataList;

  // List _categoryDataList = [];
  // get categoryDataList => _categoryDataList;

  // List _categoryKeyList = [];
  // get categoryKeyList => _categoryKeyList;

  List<Map<String, dynamic>> _dataList = [];
  get dataList => _dataList;

  String? categoryId;
  String? categoryName;

  Map<String, dynamic>? obj;

  Future<bool> insertData(
    String categoryname,
    String uuid,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('CategoryList')
          .doc(uuid)
          .set({
        'category': categoryname,
        'id': uuid,
      });

      return true;
    } catch (error) {}
    return false;
  }

  Future<bool> addSubCategoryData(
    String categoryname,
    String subCategory,
    String uuid,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('CategoryList')
          .doc(categoryId)
          .collection(categoryname)
          .doc("subCategory")
          .collection('subCategory')
          .doc(uuid)
          .set({
        'subCategory': subCategory,
        'id': uuid,
      });

      return true;
    } catch (error) {}
    return false;
  }

  Future<bool> addField(
    String categoryname,
    String subCategory,
    String uuid,
    String fieldName,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('CategoryList')
          .doc(categoryId)
          .collection(categoryname)
          .doc("Field")
          .collection('Field')
          .doc(uuid)
          .set({
        'field': fieldName,
      });

      return true;
    } catch (error) {}
    return false;
  }

  Future<bool> addFieldValueData(
      Map<String, String> map, String categoryName, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(categoryName)
          .doc(id)
          .set(map);

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<List<CategoryModel>> fetchCategoryListData() async {
    await Firebase.initializeApp();
    try {
      _categoryList.clear();
      await FirebaseFirestore.instance
          .collection('CategoryList')
          .get()
          .then((snapshot) {
        snapshot.docChanges.forEach((element) {
          CategoryModel categoryModel = CategoryModel(
            id: element.doc['id'],
            category: element.doc['category'],
          );
          categoryId = element.doc['id'];
          _categoryList.add(categoryModel);
        });
      });

      notifyListeners();
      return categoryList;
    } catch (error) {
      print('err:{$error}');
      return [];
    }
  }

  Future fetchCategoryData(
    String categoy,
  ) async {
    await Firebase.initializeApp();

    try {
      // _categoryDataList.clear();
      // _categoryKeyList.clear();
      // _subCategoryItemList.clear();
      await FirebaseFirestore.instance
          .collection(categoy)
          .get()
          .then((snapshot) {
        dataList.clear();
        snapshot.docs.forEach((element) {
          obj = element.data();
          _dataList.add(obj!);
        });
      });

      print("Category Item List : $dataList");

      notifyListeners();
      return dataList;
    } catch (error) {
      print('err:{$error}');
      return [];
    }
  }

  Future<List<CategoryModel>> fetchSubCategoryList(
    String categoy,
  ) async {
    await Firebase.initializeApp();
    try {
      _subCategorydataList.clear();
      await FirebaseFirestore.instance
          .collection('CategoryList')
          .doc(categoryId)
          .collection(categoy)
          .doc('subCategory')
          .collection('subCategory')
          .get()
          .then((snapshot) {
        snapshot.docChanges.forEach((element) {
          CategoryModel subCategoryModel = CategoryModel(
            subCategory: element.doc.get('subCategory'),
          );

          _subCategorydataList.add(subCategoryModel);
        });
      });

      return subCategorydataList;
    } catch (error) {
      print('err:{$error}');
      return [];
    }
  }

  Future fetchFieldList(
    String categoy,
  ) async {
    await Firebase.initializeApp();
    try {
      _fieldDataList.clear();
      await FirebaseFirestore.instance
          .collection('CategoryList')
          .doc(categoryId)
          .collection(categoy)
          .doc('Field')
          .collection('Field')
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<dynamic, dynamic> obj1 = element.data();

          obj1.forEach((key, value) {
            _fieldDataList.add(value);
          });
        });
      });
      print(_fieldDataList);
      return fieldDataList;
    } catch (error) {
      print('err:{$error}');
      return [];
    }
  }

  Future<bool> updateItemData(Map<String, dynamic> map, String category,
      String id, BuildContext context) async {
    print(map);
    try {
      await FirebaseFirestore.instance.collection(category).doc(id).update(map);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteItemData(
      BuildContext context, String id, String category) async {
    try {
      await FirebaseFirestore.instance.collection(category).doc(id).delete();
      return true;
    } catch (error) {
      return false;
    }
  }
}
