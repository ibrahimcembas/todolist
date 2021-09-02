import 'package:flutter/material.dart';
import 'package:todolist/http/item_service.dart';
import 'package:todolist/ui/shopping_list_history_page.dart';
import 'package:todolist/ui/shopping_list_item_page.dart';
import 'package:todolist/ui/shopping_list_main.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  int _selectedIndex = 0;
  final _scaffoldState = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  ItemService _itemService;
  @override
  void initState() {
    _itemService = ItemService();
    _pageController.addListener(() {
      int currentIndex = _pageController.page.round();
      if (currentIndex != _selectedIndex) {
        _selectedIndex = currentIndex;

        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Shopping List"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History")
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        controller: _pageController,
        children: [
          ShoppingListMainPage(),
          ShoppingListItemPage(),
          ShoppingListHistoryPage(),
        ],
      ),
    );
  }

  void _onTap(int value) {
    setState(() {
      _selectedIndex = value;
      _pageController.jumpToPage(value);
    });
  }
}
