import 'package:flutter/material.dart';
import 'package:todolist/http/item_service.dart';
import 'package:todolist/ui/overview.dart';

class ShoppingListMainPage extends StatefulWidget {
  ShoppingListMainPage({Key key}) : super(key: key);
  @override
  _ShoppingListMainPageState createState() => _ShoppingListMainPageState();
}

class _ShoppingListMainPageState extends State<ShoppingListMainPage> {
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
          title: Text('Overview'),
        ),
        FutureBuilder(
          future: _itemService.overview(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<Overview> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }
            return Expanded(
              child: Container(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    GridItem(
                        icon: Icons.shopping_basket,
                        tittle: 'Total Items',
                        total: snapshot.data.total),
                    GridItem(
                        icon: Icons.add_shopping_cart,
                        tittle: 'Current Items',
                        total: snapshot.data.current),
                    GridItem(
                        icon: Icons.history,
                        tittle: 'Completed Items',
                        total: snapshot.data.completed),
                    GridItem(
                        icon: Icons.remove_shopping_cart,
                        tittle: 'Deleted Items',
                        total: snapshot.data.deleted),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String tittle;
  final int total;
  const GridItem({
    @required this.icon,
    @required this.tittle,
    @required this.total,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.redAccent,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Text(
                tittle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Text(
              total.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
