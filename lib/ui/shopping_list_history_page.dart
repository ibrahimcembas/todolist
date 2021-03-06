import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/http/item_service.dart';

import '../item.dart';

class ShoppingListHistoryPage extends StatefulWidget {
  @override
  _ShoppingListHistoryPageState createState() =>
      _ShoppingListHistoryPageState();
}

class _ShoppingListHistoryPageState extends State<ShoppingListHistoryPage> {
  StreamController<List<Item>> _streamController = StreamController();
  ItemService _itemService;
  final ScrollController _controller = ScrollController();
  int _currentPage = 0;
  List<Item> _items = List<Item>();

  @override
  void initState() {
    _itemService = ItemService();
    _fetchArchive(_currentPage);
    _controller.addListener(_onScrolled);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> _fetchArchive(int page) async {
    int take = 20;
    var items = await _itemService.fetchArchive(20, take * page);
    if (items.length == 0) return;
    _items.addAll(items);
    _streamController.add(_items);
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Shopping List History')),
        Expanded(
          child: StreamBuilder<List<Item>>(
              stream: _streamController.stream,
              // ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.data.length == 0) {
                      return Center(
                          child: Text(
                        'Archive is Empty!',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ));
                    }
                    return ListView.builder(
                      controller: _controller,
                      padding: EdgeInsets.all(0),
                      itemCount: snapshot.data.length,
                      // ignore: missing_return
                      itemBuilder: (BuildContext context, int index) {
                        var item = snapshot.data[index];
                        return ListTile(title: Text(item.name));
                      },
                    );
                    break;
                  default:
                    return Container();
                    break;
                }
              }),
        )
      ],
    );
  }

  void _onScrolled() {
    if (_controller.position.maxScrollExtent == _controller.position.pixels) {
      _currentPage += 1;

      _fetchArchive(_currentPage);
    }
  }
}
