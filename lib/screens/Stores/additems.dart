import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/widgets/CustomButton.dart';

class AddItems extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  AddItems(this.items);
  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  List<Map<String, dynamic>> items;

  void _add(String name, double price) =>
      setState(() => items.add({'name': name, 'price': price}));
  void _edit(String name, double price, int index) =>
      setState(() => items[index] = ({'name': name, 'price': price}));

  @override
  void initState() {
    super.initState();
    items = widget.items;
    if (items == null) items = List<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Items'),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(items.length != 0 ? items : null);
                },
                child: Text('Done'))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => showModalBottomSheet(
                context: context, builder: (_) => AddItemSheet(_add)),
            child: Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: items.length == 0
            ? Center(
                child: Text(
                'Let\'s add items for your Store',
                style: MyTextStyles.label,
              ))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  var item = items[i];
                  return ListTile(
                    title: Text(
                      item['name'],
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '₹${item['price']}',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: MyColors.secondary),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.red),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => AddItemSheet(_edit,
                                item: items.elementAt(i)['name'],
                                price: items.elementAt(i)['price'],
                                index: i),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => setState(() => items.removeAt(i)))
                      ],
                    ),
                  );
                },
              ));
  }
}

class AddItemSheet extends StatefulWidget {
  final Function action;
  final String item;
  final double price;
  final int index;
  AddItemSheet(this.action, {this.item, this.price, this.index});
  @override
  _AddItemSheetState createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  String _name, _price;
  TextEditingController _nameController, _priceController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    if (widget.item != null) {
      _name = widget.item;
      _price = widget.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // bool _autovalidate = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        // autovalidate: _autovalidate,
        child: Container(
            color: MyColors.primaryLight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20.0,
                  left: 30.0,
                  right: 30.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _name,
                    style: TextStyle(fontFamily: 'Roboto', letterSpacing: 2),
                    onChanged: (value) => _name = value.trim(),
                    validator: (value) =>
                        value.trim().isEmpty ? 'Enter Item Name' : null,
                    decoration: InputDecoration(
                        labelText: 'Item',
                        labelStyle: MyTextStyles.label,
                        hintText: 'Item name',
                        errorStyle: TextStyle(fontSize: 15)),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      initialValue: _price,
                      style: TextStyle(fontFamily: 'Roboto', letterSpacing: 2),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value.trim().isEmpty)
                          return 'Enter Price';
                        else if (double.parse(value.trim()) < 1)
                          return 'Minimum price is ₹1';
                        else
                          return null;
                      },
                      onChanged: (value) => _price = value.trim(),
                      decoration: InputDecoration(
                        labelText: 'Price ₹',
                        labelStyle: MyTextStyles.label,
                        hintText: 'Price per Item',
                        errorStyle: TextStyle(fontSize: 15),
                      )),
                  SizedBox(height: 20),
                  SmallButton(
                      text: widget.item != null ? 'Edit' : 'Add',
                      action: () {
                        if (_formkey.currentState.validate()) {
                          print('$_name, ${double.parse(_price)}');
                          widget.item != null
                              ? widget.action(
                                  _name, double.parse(_price), widget.index)
                              : widget.action(_name, double.parse(_price));
                          Navigator.pop(context);
                        }
                        // else
                        // setState(() => _autovalidate = true);
                      })
                ],
              ),
            )),
      ),
    );
  }
}
