import 'package:flutter/material.dart';

class ItemDialog extends StatefulWidget {
  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final _formKey = GlobalKey<FormState>();
  String itemName;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add your shopping item.'),
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLength: 50,
                  onSaved: (value) => itemName = value,
                ),
              ),
              SizedBox(height: 16),
              FlatButton(
                onPressed: _saveForm,
                child: Text(
                  'Add Item',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _saveForm() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      Navigator.pop(context, itemName);
    }
  }
}
