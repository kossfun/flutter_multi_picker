import 'package:flutter/material.dart';
import 'multi_picker_theme.dart';
import 'custom_tab_bar.dart';

/// @param dataList
/// @param initValue              初始值
/// @param keyName                default: 'id'
/// @param valueName              default: 'name'
/// @param childrenName           default: 'children'
/// @param newTabName             default: '请选择' [主要用于国际化]
/// @param onValueChange
/// @param onSelectValueChange

class MultiPicker extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;
  final List<int> initValue;
  final String keyName;
  final String valueName;
  final String childrenName;
  final String newTabName;
  final MultiPickerTheme theme;
  final ValueChanged<List<Map<String, dynamic>>> onValueChange;
  final ValueChanged<List<int>> onSelectChange;

  MultiPicker(
      {Key key,
        @required this.dataList,
        this.initValue,
        this.keyName = 'id',
        this.valueName = 'name',
        this.childrenName = 'children',
        this.newTabName = '请选择',
        this.onValueChange,
        this.theme,
        this.onSelectChange})
      : super(key: key);

  @override
  _MultiPickerState createState() => _MultiPickerState();
}

class _MultiPickerState extends State<MultiPicker> with TickerProviderStateMixin {
  TabController _tabController;
  List<Map<String, dynamic>> _tabs = [];
  List<int> _selTabs = [];
  var _pagesListData = Map<int, List<dynamic>>();

  MultiPickerTheme _theme;

  @override
  void initState() {
    super.initState();
    if (widget.theme == null) {
      _theme = MultiPickerTheme();
    } else {
      _theme = widget.theme;
    }
    init();
  }

  void init() {
    if (widget.initValue != null && widget.initValue.length > 0) {
      _selTabs = [...widget.initValue];
      for (int i = 0; i < _selTabs.length; i++) {
        if (i == 0) {
          _pagesListData.putIfAbsent(0, () => widget.dataList);
          _tabs.add({
            widget.keyName: widget.dataList[_selTabs[i]][widget.keyName],
            widget.valueName: widget.dataList[_selTabs[i]][widget.valueName],
          });
        } else {
          var children =
          _pagesListData[i - 1][_selTabs[i - 1]][widget.childrenName];
          _pagesListData.putIfAbsent(i, () => children);

          _tabs.add({
            widget.keyName: children[_selTabs[i]][widget.keyName],
            widget.valueName: children[_selTabs[i]][widget.valueName],
          });
        }
      }

      _tabController = TabController(
          length: _tabs.length, initialIndex: _tabs.length - 1, vsync: this);
      return;
    }

    _tabs.add({widget.keyName: 0, widget.valueName: widget.newTabName});
    _selTabs.add(-1);
    _pagesListData.putIfAbsent(0, () => widget.dataList);

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: CustomTabBar(
              height: _theme.tabHeight,
              isScrollable: true,
              controller: _tabController,
              items: _tabs.map((e) => e[widget.valueName].toString()).toList(),
              unselectedLabelColor: _theme.tabUnselectedLabelColor,
              labelColor: _theme.tabLabelColor,
              bgColor: _theme.tabBgColor,
              indicatorColor: _theme.tabIndicatorColor,
              indicatorWidth: _theme.tabIndicatorWidth,
              indicatorWeight: _theme.tabIndicatorWeight,
              labelPadding: _theme.tabLabelPadding,
              labelStyle: _theme.tabLabelStyle,
              unselectedLabelStyle: _theme.tabUnselectedLabelStyle,
              bottomBorder: _theme.tabBottomBorder,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPage() {
    List<Widget> list = [];
    for (int page = 0; page < _tabs.length; page++) {
      List<dynamic> pageListData = _pagesListData[page];

      list.add(PickerList(
        key: ValueKey('page_$page'),
        list: pageListData,
        valueName: widget.valueName,
        selIndex: _selTabs[page],
        labelColor: _theme.listLabelColor,
        unselectedLabelColor: _theme.listUnselectedLabelColor,
        labelStyle: _theme.listLabelStyle,
        unselectedLabelStyle: _theme.listUnselectedLabelStyle,
        onTapItem: (index) {
          _onTapItem(pageListData, page, index);
        },
      ));
    }
    return list;
  }

  /// @params pageListData 当前页数据
  /// @params page 当前页index
  /// @params index 点击item的index
  void _onTapItem(List<dynamic> pageListData, int page, int index) {
    _tabs[page] = {
      widget.keyName: pageListData[index][widget.keyName],
      widget.valueName: pageListData[index][widget.valueName]
    };
    _selTabs[page] = index;


    if (pageListData[index][widget.childrenName] == null) {
      if (page != _tabs.length - 1) {
        _tabs.removeRange(page + 1, _tabs.length);
        _selTabs.removeRange(page + 1, _selTabs.length);
      }

      _tabController = TabController(length: _tabs.length, initialIndex: _tabs.length -1, vsync: this);
      /// print('选择的数据:    $_tabs');
      /// print('选择的index:    $_selTabs');
      if (widget.onValueChange != null) {
        widget.onValueChange(_tabs);
      }
      if (widget.onSelectChange != null) {
        widget.onSelectChange(_selTabs);
      }
      setState(() {});
      return;
    }

    if (page == _tabs.length - 1) {
      // 当前页点击item
      // 添加tab
      _tabs.add({widget.keyName: 0, widget.valueName: widget.newTabName});
      _selTabs.add(-1);
      // 添加新页面数据
      _pagesListData.putIfAbsent(
          page + 1, () => pageListData[index][widget.childrenName]);
    } else {
      // 非当前页点击item
      // 删除非当前页的tab
      _tabs.removeRange(page + 1, _tabs.length);
      _selTabs.removeRange(page + 1, _selTabs.length);
      // 清空非当前页的数据
      _pagesListData.removeWhere((key, value) => key > page);

      // 更新当前tab
      _tabs[page] = {
        widget.keyName: pageListData[index][widget.keyName],
        widget.valueName: pageListData[index][widget.valueName]
      };
      _selTabs[page] = index;
      // 添加tab
      _tabs.add({widget.keyName: 0, widget.valueName: widget.newTabName});
      _selTabs.add(-1);
      // 更新下一页数据
      _pagesListData.putIfAbsent(
          page + 1, () => pageListData[index][widget.childrenName]);
    }

    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.animateTo(page + 1);
    setState(() {});
  }
}



class PickerList extends StatefulWidget {
  final List<dynamic> list;
  final String valueName;
  final int selIndex;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;

  final ValueChanged<int> onTapItem;

  PickerList(
      {Key key,
        this.list,
        this.valueName = 'name',
        this.selIndex = -1,
        this.labelColor = Colors.blueAccent,
        this.unselectedLabelColor = Colors.black87,
        this.labelStyle,
        this.unselectedLabelStyle,
        this.onTapItem})
      : super(key: key);

  @override
  _PickerListState createState() => _PickerListState();
}

class _PickerListState extends State<PickerList> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    double offset = 0;
    if (widget.selIndex > 5) {
      offset = (50 * (widget.selIndex - 4)).toDouble();
    }
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.list.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (widget.onTapItem != null) {
              widget.onTapItem(index);
            }
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.list[index][widget.valueName],
              style: TextStyle(
                color: widget.selIndex == index
                    ? widget.labelColor
                    : widget.unselectedLabelColor,
              ).merge(widget.selIndex == index
                  ? widget.labelStyle
                  : widget.unselectedLabelStyle),
            ),
          ),
        );
      },
    );
  }
}
