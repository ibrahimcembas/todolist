import 'package:flutter/material.dart';
import 'package:todolist/http/item_service.dart';
import 'package:todolist/item.dart';

import 'dialog/confirm_dialog.dart';
import 'dialog/item_dialog.dart';

class ShoppingListItemPage extends StatefulWidget {
  @override
  _ShoppingListItemPageState createState() => _ShoppingListItemPageState();
}

class _ShoppingListItemPageState extends State<ShoppingListItemPage> {
  ItemService _itemService;

  @override
  void initState() {
    _itemService = ItemService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Shopping List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done_all),
              onPressed: () async {
                await _itemService.addToArchive();
                setState(() {});
              },
            )
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              FutureBuilder(
                future: _itemService.fetchItems(),
                // ignore: missing_return
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data.length == 0) {
                    return Center(
                        child: Text(
                      'Your shopping list is empty!',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ));
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Item item = snapshot.data[index];
                          return GestureDetector(
                            onLongPress: () async {
                              bool result = await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ConfirmDialog(item: item),
                              );
                              item.isArchived = result;
                              await _itemService.editItem(item);
                              setState(() {});
                            },
                            child: CheckboxListTile(
                              title: Text(item.name),
                              onChanged: (bool value) async {
                                item.isCompleted = !item.isCompleted;
                                await _itemService.editItem(item);
                                setState(() {});
                              },
                              value: item.isCompleted,
                            ),
                          );
                        });
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () async {
                    String itemNamee = await showDialog(
                        context: context,
                        builder: (BuildContext context) => ItemDialog());
                    if (itemNamee != null && itemNamee.isNotEmpty) {
                      var item = Item(
                          name: itemNamee,
                          isCompleted: false,
                          isArchived: false);

                      try {
                        await _itemService.addItem(item);
                      } catch (ex) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(ex.toString())));
                      }

                      setState(() {});
                    }
                    print(itemNamee);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
