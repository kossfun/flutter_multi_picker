import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_multi_picker/flutter_multi_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> pickerList = [];
  List<Map<String, dynamic>> customList = [];
  List<Map<String, dynamic>> pcaList = [];
  List<Map<String, dynamic>> pcasList = [];
  List<Map<String, dynamic>> selectValue = [];
  List<int> pickerSelectIndex = [];
  List<int> customSelectIndex = [];
  List<int> pcaSelectIndex = [];
  List<int> pcasSelectIndex = [];

  @override
  void initState() {
    super.initState();
    loadPickerList();
    loadCustomPickerList();
    loadPcaList();
    loadPcasList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiPicker Example App'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$selectValue'),
            RaisedButton(
              onPressed: () {
                showBottomPicker();
              },
              child: Text('Picker'),
            ),
            RaisedButton(
              onPressed: () {
                showBottomCustomPicker();
              },
              child: Text('Custom Picker'),
            ),
            RaisedButton(
              onPressed: () {
                showPcaBottomPicker();
              },
              child: Text('PCA Picker'),
            ),
            RaisedButton(
              onPressed: () {
                showPcasBottomPicker();
              },
              child: Text('PCAS Picker'),
            ),
          ],
        ),
      ),
    );
  }

  void loadPickerList() {
    DefaultAssetBundle.of(context)
        .loadString('assets/data/pickerData.json')
        .then((value) {
      var jsonData = jsonDecode(value);

      pickerList = listToTree(dataList: jsonData);
    });
  }

  void loadCustomPickerList() {
    DefaultAssetBundle.of(context)
        .loadString('assets/data/customData.json')
        .then((value) {
      var jsonData = jsonDecode(value);

      customList = listToTree(dataList: jsonData, keyName: 'value', pidName: 'level', childrenName: 'data');
      print(customList);
    });
  }

  void loadPcaList() {
    DefaultAssetBundle.of(context)
        .loadString('assets/data/pca.json')
        .then((value) {
      var jsonData = jsonDecode(value);
      jsonData.forEach((el) {
        pcaList.add(el);
      });
    });
  }

  void loadPcasList() {
    DefaultAssetBundle.of(context)
        .loadString('assets/data/pcas.json')
        .then((value) {
      var jsonData = jsonDecode(value);
      jsonData.forEach((el) {
        pcasList.add(el);
      });
    });
  }

  void showBottomPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: MultiPicker(
                  dataList: pickerList,
                  initValue: pickerSelectIndex,
                  onValueChange: (value) {
                    Navigator.pop(context, value);
                  },
                  onSelectChange: (value) {
                    setState(() {
                      pickerSelectIndex = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectValue = value;
        });
      }
    });
  }

void showBottomCustomPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: MultiPicker(
                  dataList: customList,
                  initValue: customSelectIndex,
                  keyName: 'value',
                  valueName: 'title',
                  childrenName: 'data',
                  onValueChange: (value) {
                    Navigator.pop(context, value);
                  },
                  onSelectChange: (value) {
                    setState(() {
                      customSelectIndex = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectValue = value;
        });
      }
    });
  }

  void showPcaBottomPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: MultiPicker(
                  dataList: pcaList,
                  initValue: pcaSelectIndex,
                  keyName: 'code',
                  onValueChange: (value) {
                    Navigator.pop(context, value);
                  },
                  onSelectChange: (value) {
                    setState(() {
                      pcaSelectIndex = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectValue = value;
        });
      }
    });
  }

  void showPcasBottomPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: MultiPicker(
                  dataList: pcasList,
                  initValue: pcasSelectIndex,
                  keyName: 'code',
                  onValueChange: (value) {
                    Navigator.pop(context, value);
                  },
                  onSelectChange: (value) {
                    setState(() {
                      pcasSelectIndex = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectValue = value;
        });
      }
    });
  }

  List<Map<String, dynamic>> listToTree({
    List<dynamic> dataList,
    String keyName = 'id',
    String pidName = 'pid',
    String childrenName = 'children',
  }) {
    var newList = <Map<String, dynamic>>[];
    var newMap = <dynamic, dynamic>{};

    dataList.forEach((el) {
      newMap.putIfAbsent(el[keyName], () => el);
    });

    dataList.forEach((el) {
      var parent = newMap[el[pidName]];

      if (parent != null) {
        if (parent[childrenName] == null) {
          var ch = <Map<String, dynamic>>[];
          ch.add(el);
          parent[childrenName] = ch;
        } else {
          var ch = parent[childrenName];
          ch.add(el);
          parent[childrenName] = ch;
        }
      } else {
        newList.add(el);
      }
    });
    return newList;
  }
}
